# Reverse-engineering LLM CLI surfaces in a container

Working notes toward a blog post. What we can observe about a vendor coding-agent
CLI from outside its source: the files it reads, the files it writes, and the
tools it calls — and whether that observation can be turned into universal
context injection. Draft; snippets are real unless marked otherwise.

## Why

ctxloom drives several vendor CLIs (claude, codex, kiro, opencode, antigravity).
We do not own any of them, and none documents its full file contract. To deliver
context to one, ctxloom has to know exactly where that CLI looks — which
instruction file, which settings path, which MCP config, in which precedence.
Until now that map came from reading our own integration code, which is a guess
about the vendor's behavior, not a measurement of it. When the guess is wrong the
failure is silent: ctxloom writes a file the CLI never reads, the run succeeds,
and no context was delivered.

The probe replaces the guess with a measurement. Run the real CLI in a container,
watch what it touches, and read the contract off the syscalls.

## The three observation planes

### 1. Writes — `docker diff`

The cheapest signal. A container's writable layer records every file the process
created, changed, or deleted relative to the image. `docker diff <name>` prints
it as `A`/`C`/`D` path lines.

Mechanism (`tests/acceptance/isolation_probe.go`): the probe polls
`docker ps --filter name=ctxloom-iso-` to catch the container the instant it is
up, then runs `docker diff` every 40ms until the container disappears, keeping the
last non-empty enumeration. It races `--rm` teardown on purpose — a `--rm`
container is gone before a post-hoc inspection could run, so the diff has to be
sampled while it lives. A hand-curated allowlist subtracts runtime bootstrap noise
(`/etc/hosts`, `~/.npm`, `.config/configstore`, and so on).

Limitation, and it is the important one: **`docker diff` sees writes only.** It
reports the writable-layer delta. It cannot see a read. The paths where a CLI
*looks* for context — the whole point — are invisible to it, because looking is
reading. So the write plane tells you what the CLI produced (transcript stores,
caches, config it rewrote), not what it consumed.

### 2. Reads — `strace` via a probe-only seccomp profile

To see reads we trace syscalls. `strace -f -e trace=open,openat,stat,lstat,newfstatat,statx,access,faccessat,readlink,readlinkat`
follows the process and its children and logs every file-name syscall with its
result — including the failures. The stat family matters as much as `openat`: a
CLI usually `access()`es or `stat()`s a path before opening it, and an `ENOENT`
from `access` is exactly as informative as one from `openat`.

The delicate part is running `strace` in a container without weakening the
isolation the probe exists to characterize. The naive way — `--cap-add=SYS_PTRACE`
— grants the container privileged, any-process ptrace, which changes the security
posture we are trying to measure. It is also unnecessary. `strace` launches the
engine as its own child, so the ptrace permission model needs no capability at all
(a parent may trace its own child; the host's `ptrace_scope` is 0 anyway). The
only thing in the way is Docker's default seccomp profile, which denies the
`ptrace` family unless `CAP_SYS_PTRACE` is present.

So the probe ships a **probe-only seccomp profile** (`container/seccomp/probe-seccomp.json`):
Docker's default profile, tightened to `defaultAction: SCMP_ACT_ERRNO`, with
`ptrace`, `process_vm_readv`, and `process_vm_writev` moved to `SCMP_ACT_ALLOW`.
It is passed with `--security-opt seccomp=<file>`, not `seccomp=unconfined`. This
is a far smaller privilege delta than the capability: it lets a process trace
processes it could already trace by same-uid rules (its own children), and grants
none of the cross-process ptrace the capability confers.

The security boundary is structural, not conventional. `renderRunSpec` applies the
seccomp override if and only if `RunSpec.Trace != nil`. `nil` is the zero value
every production spec builder produces; the sole setter reads a dedicated env var
(`CTXLOOM_ISOLATION_PROBE_TRACE_DIR`) that production never sets. A normal
`ctxloom run` keeps Docker's default profile, no override, no capability — asserted
by `TestRenderRunSpec_NoTraceProbe_NoSeccompOverride` across Docker and Podman,
rootful and rootless.

The trace leaves the `--rm` container by being written to a bind-mounted directory
from inside (`-o /ctxloom-probe-trace/reads.strace`), so there is no teardown race
like the `docker diff` poll — the file is simply on disk when the container is
gone. `ParseStraceReads` turns it into a sorted, deduplicated
`[]TraceRead{Path, Syscall, Result}`, with `ENOENT`/`EACCES` first-class
(`TraceRead.Failed()`), never filtered.

One measurement-hygiene bug worth recording: the first live run failed because
`docker diff` flagged the probe's own `/ctxloom-probe-trace` mount as an
"unexpected write" — the instrument corrupting the write census. The fix was to
exclude the probe's own mount from the write assertion. The general rule: the
instrument must not appear in the measurement.

### 3. Tool and command calls — the transcript

The first two planes are about files. The third is about behavior: what the agent
actually *did* — which tools it invoked, in what order. ctxloom already captures
this. Every engine turn is recorded to
`~/.ctxloom/sessions/<harp>/persist/transcript.jsonl`, one JSON object per line,
with an `entry` payload whose `type` is one of
`user | assistant | thinking | tool_use | tool_result | system`. The `tool_use`
and `tool_result` entries are the command/file calls the agent made through its
own tool interface (as opposed to the syscalls its process made, which is plane 2).

Two different layers, worth not conflating: plane 2 is what the CLI *process* read
from the filesystem; plane 3 is what the *agent* asked its harness to do. A CLI
that reads `~/.claude/settings.json` (plane 2) and then issues a `Bash` tool call
(plane 3) is doing two different things at two different layers.

## What we learned — claude, the worked example

`just isolation-probe claude-code container` → `result=PASSED`, **1685 unique
reads** including `ENOENT`/`EACCES`. Real rows:

    access   ok      /home/ctxloom/.claude
    openat   ok      /home/ctxloom/.claude.json
    access   ENOENT  /home/ctxloom/.claude/CLAUDE.md
    openat   ENOENT  /home/ctxloom/.claude/settings.json
    access   ENOENT  <project>/.claude/settings.local.json
    access   ENOENT  <project>/CLAUDE.md
    access   ENOENT  /tmp/CLAUDE.md
    access   ENOENT  /etc/claude-code/CLAUDE.md
    openat   ENOENT  /etc/claude-code/managed-settings.json

Every one of those `ENOENT` rows is a fact we did not have from reading our own
code, and several answered open questions:

- **claude walks a directory hierarchy for `CLAUDE.md`** — project dir, then `/tmp`,
  up toward root. We had modeled a single project-root write.
- **`~/.claude/CLAUDE.md`** (user-level memory) is consulted. We did not model it.
- **`.claude/settings.local.json`** is a real settings surface. We did not model it.
- **`/etc/claude-code/managed-settings.json`** — an enterprise/managed-policy layer
  the CLI probes for. We had no idea it existed.

This is the payoff, and it is entirely in the failures. `docker diff` could never
have shown any of it, because the CLI wrote none of these files — it looked for
them. **The `ENOENT` set is a specification of the engine's config contract,
read off the binary without a line of its documentation.**

## From observation to injection — future possibilities

Not a current work item. The team parked context-injection-via-interception in July
2026; what ctxloom does today is (A) observe-then-materialize below. This section is
kept as a map of the option space for when it's revived — the mechanisms, their
privilege cost, and which engines admit which.

If the reads tell us every path an engine will accept context at, can we act on
that map to *deliver* context — universally, without knowing each engine's config
format up front? Yes, along a spectrum. The distinction that matters is where the
mechanism runs: in the container (mostly unprivileged) or on the host (needs
superuser for a process we didn't launch — but not for one we did; see (C)).

### (A) Observe, then materialize — zero interception

This is what ctxloom already does, and the probe upgrades it. Discover the read
paths (plane 2, including the `ENOENT` ones the engine would have accepted), then
write ctxloom's context to those paths before the engine runs. The engine opens
the file and finds our content. No interception at all — we are not catching a
read, we are putting the file where the read will land.

- **Privilege:** none beyond writing into the workspace.
- **Coverage:** every engine, regardless of how it is linked or how it makes
  syscalls, because nothing is being hooked.
- **Limit:** the paths must be knowable ahead of time and stable, and the content
  is fixed for the run. That is exactly the shape of context files, so for context
  delivery this is sufficient almost always. The probe is what makes the paths
  knowable — it turns "guess where claude reads `CLAUDE.md`" into the measured
  hierarchy above.

For context injection this is the recommended mechanism. The two below are only
needed when a path is not knowable ahead of time, or the content must vary per
read.

### (B) In-container runtime interception — for dynamic paths or lazy content

Catch the read as it happens, from inside the container.

- **`LD_PRELOAD` `open`/`openat` shim.** Preload a small `.so` that intercepts the
  libc file calls, checks the path, and returns an fd to our content. Runs entirely
  in-container, needs no extra privilege (an env var plus a library the entrypoint
  sets). The catch is decisive: it only works for **dynamically-linked binaries
  that call through libc.** A statically-linked Go binary issues syscalls directly
  and never enters libc, so an `LD_PRELOAD` shim is blind to it. This is why the
  static-vs-dynamic linking of each engine binary matters (measured per engine
  below): claude is Node (through libc, shimmable); a static Go CLI is not.
- **FUSE mount inside the container** at the read paths. Serve content on `open`,
  at the VFS layer, below libc — so it works regardless of linking, and handles
  dynamic paths and lazily-computed content. Cost: it needs `/dev/fuse` and
  `fusermount`, i.e. a container-config privilege (a device plus either
  `CAP_SYS_ADMIN` or a rootless-FUSE setup). More invasive than materialization,
  but format-agnostic.

### (C) Host-side, and the launcher advantage

An earlier version of these notes called host-side interception superuser-only.
That is wrong for our case, and the distinction is the one worth drawing: it turns
on whether we *launch* the process. ctxloom always spawns the engine, so it is the
parent and controls the child's environment — which makes most host-side
interception unprivileged, no container required. Measured on this host:
`ptrace_scope=0`, unprivileged user namespaces enabled (`unshare -Urm` succeeds),
`fusermount` present. As the launching parent, on the bare host, unprivileged:

- **Env path redirection.** Patch the read path by setting the child's environment
  (`HOME`, `XDG_CONFIG_HOME`, and tool-specific vars like `CODEX_HOME`). Zero
  interception — the engine derives the path from env and we point it at a
  directory we prepared. ctxloom already does this for codex. Limit: only paths the
  engine derives from env, not ones hardcoded absolute or resolved from the passwd
  entry rather than `$HOME`.
- **`LD_PRELOAD` shim.** Set it in the child's env at launch; intercept libc
  `open`/`openat`/`stat`/`access` and redirect or serve. Unprivileged, no container.
  Catches a read only if the runtime routes it through libc — and that is NOT the
  same as dynamic linking. Measured: all the vendor binaries here are dynamically
  linked, yet Go (`agy`) issues `openat` directly and bypasses libc, so a preload
  shim is blind to its reads; Rust (`kiro`, `codex`) and Node go through libc and
  are caught; bun (`opencode`) is mixed — its Zig core does raw syscalls a shim
  misses.
- **Parent `ptrace`.** Because we forked the engine we may trace it with no
  capability (a parent tracing its own child is always permitted; `ptrace_scope=0`
  here regardless). Intercept at the syscall boundary and rewrite the path argument
  or the result. Works for **any** binary, static Go included — the case
  `LD_PRELOAD` cannot reach. The Docker seccomp block that forced the probe's custom
  profile inside a container does not exist on the bare host, so no profile work is
  needed. Cost: a trap per syscall, plus the ABI and pointer-rewriting complexity.
  This is `strace` extended from observing to intervening.
- **Unprivileged mount namespace.** `unshare -Urm` (verified working here) gives
  the child a private mount namespace in which we bind-mount or overlay our files
  over the exact paths the engine reads. Any binary, at the VFS layer, no root —
  the container's filesystem trick without the container, and the cleanest robust
  host-side path-patch. Caveat: needs unprivileged user namespaces enabled, on by
  default here and disabled on some hardened distros.
- **Host FUSE via `fusermount`** (present here). Mount a FUSE filesystem at the
  read paths and serve on open. Any binary, unprivileged where `fusermount` exists.

What genuinely needs host root: attaching to a process we did **not** launch,
seccomp user-notification `addfd`, and eBPF. Since we own the launch, we need none
of them.

macOS is the constrained case: no unprivileged ptrace-equivalent, SIP blocks
`DYLD_INSERT_LIBRARIES` (the `LD_PRELOAD` analog) for signed binaries, and there is
no unprivileged mount namespace. Host-side OS-level interception is largely a Linux
story; on macOS the OS levers stay env redirection and pre-materialization, part of
why credentials and containers are more of a fight there.

### (D) Patch the runtime — interpreted engines, and cross-platform

The layers above are the OS (syscalls, mounts) and the workspace (files). There is
one more, above both: the engine's own language runtime. For an interpreted or JIT
engine we can monkey-patch its file APIs directly, and unlike the OS-level hooks the
mechanism is cross-platform and unprivileged, because it rides the runtime's own
preload hook — which we set as the launcher, through env.

- **Node** (claude-code / claude-code-acp): `NODE_OPTIONS="--require /path/patch.js"`
  (or `--import` for ESM). Node runs our module before the CLI's entry point, and it
  monkey-patches `fs.readFile`/`readFileSync`/`openSync`/`fs.promises` to redirect a
  path or return our content. We own `NODE_OPTIONS` because we spawn the process.
  Works on Linux, macOS, and Windows.
- **Bun** (opencode, if Bun-based): `--preload` does the same.
- **Python** engines: `sitecustomize` / `PYTHONSTARTUP`, patch `open`/`io`.

This is the cleanest option where it applies. It sees the *logical* path the app
asked for, in the app's own language, with full context, and returns content
directly — no fd or pointer juggling, no seccomp, no ptrace, no VM. The catch is
that it is per-runtime and exists only for interpreted/JIT runtimes. A compiled
engine — Go (`agy`) or Rust (`kiro`, `codex`) — has no interpreter or env-driven
loader to hook, so its runtime layer is empty and you fall back to
pre-materialization (portable) or the Linux syscall/mount options.

There are two independent axes here, and neither is "static vs dynamic linking"
(measured: every engine is dynamically linked):

- **Monkey-patch** needs an interpreted runtime with an env preload hook. Node
  (`--require`) and bun (`--preload`): yes, and cross-platform. Rust and Go: no.
- **`LD_PRELOAD`** needs the runtime to reach the filesystem through libc. Node and
  Rust: yes. Go: no — it issues raw syscalls even when dynamically linked. bun:
  partial.

So Rust engines admit `LD_PRELOAD` but not monkey-patch; Node admits both; Go
(`agy`) admits neither and is the hard case. (A patchable Node runtime can still be
resisted — an app reading through `process.binding('fs')` or an internal `node:`
binding rather than the public `fs` module sidesteps a surface patch; normal npm
CLIs like `claude-code-acp` use the public API.)

### The synthesis

Two independent axes: container vs host, and whether we launch the process. Because
ctxloom always launches the engine, the launcher-controlled host options are
unprivileged — so "must use a container" and "must be root" are both weaker
constraints than they first appear. For delivering context (static files at
discoverable paths) the ranking is:

1. **Env redirection**, when the engine derives the path from env. Zero cost,
   already in use for codex.
2. **Pre-materialize at the discovered paths** — observe-then-materialize, in a
   workspace or an unprivileged mount-namespace overlay. Any binary, no root,
   handles paths not derivable from env. The workhorse.
3. **Parent-ptrace or FUSE**, only when a path is computed at runtime and cannot be
   pre-placed, or must serve content that varies per read.

The read-probe is the enabler for all of them: it discovers the paths (including
the `ENOENT` ones the engine would accept), and whichever mechanism you pick just
answers at those paths. **An engine's `ENOENT` reads are a request for content it
did not find; materializing or serving at those paths is answering the request** —
discovered by observation, delivered without ever parsing the vendor's config
format. Per-engine linking (static vs dynamic) and path style (fixed vs dynamic)
decide which mechanisms are in play, measured next.

## Portability — discovery is Linux-only, delivery is portable

The OS-level interception mechanisms are Linux-specific, and several are not even
portable POSIX. User and mount namespaces (`unshare -Urm`) are Linux-only. `ptrace`
and `LD_PRELOAD` exist on other Unixes in principle but not usably on macOS — SIP
blocks `DYLD_INSERT_LIBRARIES` for signed binaries, and `task_for_pid` needs an
entitlement or root. Windows is a different world (no POSIX; DLL injection or a
filesystem minifilter, both needing admin or signing). Containers are themselves a
Linux facility — Docker on macOS or Windows is a Linux VM — so the whole container
read-probe runs on Linux, natively or in that VM.

Three mechanisms are cross-platform. Two are OS-agnostic by nature: **env path
redirection** (env vars work everywhere) and **pre-materialization** (writing files
where the engine looks is portable). The third is **runtime monkey-patching (D)** —
cross-platform, but only for interpreted engines (Node/Bun/Python), because it rides
the language runtime's preload hook rather than the OS. For a Node engine, that
makes interception itself portable, not Linux-bound; for a compiled Go/Rust engine
there is no runtime to patch, so on non-Linux you are back to env redirection and
pre-materialization.

So the split that matters: **discovery is Linux-only; delivery is portable.** Run
the strace/container read-probe once per engine on Linux to learn where it reads —
the hierarchy walk, the `ENOENT` paths, the managed-settings layer — and encode
that in the engine's surface declaration. Then deliver on any platform by
materializing at those known paths, or by env-redirecting the ones the engine
derives from env. The expensive, Linux-bound part happens once and offline; the
per-run delivery is portable and unprivileged everywhere. The Linux-only
interception options (parent-ptrace, mount-namespace overlay, FUSE) stay a
same-host optimization for what pre-materialization can't cover, not a
cross-platform requirement.

## Dependencies

- **Docker** (or Podman). The write plane is `docker diff`; the read plane is a
  seccomp-profiled `docker run`.
- **`strace`** in the probe image. Added to the agent base tool layer
  (`container/base/Containerfile` + `baseContractLayer`), not the overlay path,
  because the composed engine images build through the base. A `--base-image`
  override would need `strace` pre-present.
- **The probe-only seccomp profile** (`container/seccomp/probe-seccomp.json`),
  embedded and applied only when `RunSpec.Trace != nil`.
- **Host kernel** with seccomp (standard) and `ptrace_scope` permitting a parent to
  trace its child (0 on this host; strace-parents-child needs no capability
  regardless).
- **Credentials.** A live turn needs the engine authenticated. On Linux the probe
  mounts the host credential dir into the container (e.g. `~/.claude`), so a host
  login is enough. On macOS a Keychain-held subscription login cannot be mounted,
  so containerized-macOS probing needs an API-key env var, or host-side Keychain
  extraction into a mountable file (open follow-up). Each live cell is one paid
  engine call.

## How to run it

    just isolation-probe <engine> container    # engine ∈ claude-code|codex|kiro|opencode|antigravity

The read-set and write-set land in the probe's report. The trace itself is written
to the bind-mounted probe directory inside the run and parsed out after.

## Limitations

- `docker diff` is write-only; reads need the strace plane. Neither sees file
  *content*, only paths — deliberate (paths are the contract; content could carry
  secrets).
- The strace parser is line-oriented and skips split syscall lines
  (`<unfinished>`/`<... resumed>`) under heavy threading; not seen in practice yet.
- A live turn is a real, paid engine call, and is non-deterministic. The startup
  read-set (everything the CLI probes before it needs the model) is deterministic
  and is captured even when auth fails — often enough on its own for surface
  discovery.

## Engines measured

Ran `just isolation-probe <engine> container` for the three non-claude engines. Two
ran; two could not authenticate in a container on this host — itself a finding.

### opencode — ran (bun/JS)

Live turn, one paid call, exit 0. 11272 unique reads, of which ~10035 are runtime
`node_modules` plugin-install noise. The real surfaces:

- **Context files, all `ENOENT`:** it probes fixed literals `AGENTS.md`,
  `CLAUDE.md`, `CONTEXT.md` at the project root, plus `~/.config/opencode/AGENTS.md`
  and `~/.claude/CLAUDE.md`. None present. ctxloom delivers its fragments through
  opencode's *config* channel (a seeded `opencode.jsonc` plus a project-cwd
  `opencode.json`), not a context file — so opencode's own `AGENTS.md` read is an
  available, unused injection vector.
- **Config:** probes `config.json` / `opencode.json` / `opencode.jsonc`; reads the
  `.jsonc` ctxloom seeded. MCP config is inline in that file, no separate MCP path.
- **Command/agent/skill dirs:** probes `.opencode/{command,agent,mode,skill,plugin}`
  in both singular and plural, all `ENOENT`.
- **Writes** stayed inside the container `$HOME` plus the ctxloom MCP socket; nothing
  outside `$HOME`.
- Paths are predictable literals — no per-run hash, no hierarchy walk. Dynamically
  linked, libc; runtime bun (V8, `/$bunfs`).

### kiro — could not run (Rust)

SKIPPED before any image build. kiro's container path has no credential fallback:
its subscription login lives in `~/.local/share/kiro-cli/data.sqlite3`, only
`KIRO_API_KEY` authenticates a containerized kiro, and it isn't set. No read-set
obtainable here. Dynamically linked, libc; runtime Rust.

### antigravity — could not run (Go+V8)

FAILED after image selection. ctxloom's production auth resolver aborted because the
file-based token `~/.gemini/antigravity-cli/antigravity-oauth-token` is absent —
`agy` authenticates through the OS keyring on the host, which can't be mounted into
a container. The engine never exec'd; zero reads. Dynamically linked, libc; runtime
Go + V8 hybrid.

A probe bug surfaced here: the probe's auth heuristic over-reports antigravity
availability. It copies `google_accounts.json` / `settings.json` / `installation_id`
(all present, none of them the credential), sees a non-empty census, declares
"seeded", and launches a run that production then refuses. It should check for
`antigravity-oauth-token` specifically, the way it already special-cases kiro's
`KIRO_API_KEY`.

### Injection matrix (corrected)

Every engine is dynamically linked, so linking is not the axis. The two that matter:

| engine | runtime | monkey-patch (preload) | LD_PRELOAD (libc) | pre-materialize |
|---|---|---|---|---|
| claude | Node | yes — `NODE_OPTIONS --require`, cross-platform | yes | yes |
| opencode | bun | yes — bun `--preload`, cross-platform | partial (Zig core raw syscalls) | yes |
| kiro | Rust | no (compiled) | yes (`std::fs` → libc) | yes |
| codex | Rust | no (compiled) | yes | yes |
| antigravity | Go+V8 | no (Go core) | no — Go issues `openat` directly | yes |

Reading it: **claude (Node)** is the easy case — monkey-patch cross-platform, or
`LD_PRELOAD`, or pre-materialize. **opencode (bun)** gets bun `--preload`
cross-platform, and already leaves `AGENTS.md` on the table. **kiro/codex (Rust)**
have no runtime to patch but `LD_PRELOAD` works on Linux. **antigravity (Go)** is the
hard one: neither monkey-patch nor `LD_PRELOAD` reaches its Go-side reads, so only
pre-materialization (portable) or the Linux syscall/mount options do.
Pre-materialization is the single mechanism that works for every engine, every OS,
unprivileged — which is why it is the workhorse and the rest are optimizations.

### Not measurable on this host

kiro and antigravity cannot be probed on the container axis here: neither has a
file-based credential a container can mount (kiro's is a sqlite store, antigravity's
is the OS keyring). Their read-sets need `KIRO_API_KEY` / `agy` re-authenticated to
write a token file, or the host-side (non-container) probe axis — which, given the
runtime findings, is anyway the more representative place to measure agy, since its
Go reads are the ones interception can't reach in a container without ptrace.

### Declared surfaces for the engines not measured here

For codex, kiro, and antigravity we have the surfaces ctxloom's own integration
writes and expects — a declaration, not a measurement. Listing them completes the
map; each still wants a real read-set (the ENOENT probes, hierarchy walks, managed
layers) that only a live trace reveals.

- **codex** (Rust; not yet probed — it likely has a mountable API-key / `~/.codex`
  auth path, so a container cell is a feasible follow-up): context `AGENTS.md` at
  the workspace root; `.codex/config.toml` folding hooks and MCP into one file;
  commands and skills under `$CODEX_HOME/prompts` and `/skills`. The run-path
  context is hook-mediated — a per-run `<hash>.md` under `.ctxloom/cache/context`
  read by the `config.toml` SessionStart hook, not opened by codex directly.
- **kiro** (Rust; blocked on container cred): context
  `.kiro/steering/ctxloom-context.md` (auto-loaded steering, no flag); MCP
  `.kiro/settings/mcp.json`; settings `.kiro/agents/<name>.json` (selected by
  `--agent`); commands and skills under `.kiro/skills/<name>/SKILL.md`.
- **antigravity** (Go; blocked on container cred): context `.agents/AGENTS.md`
  (auto-read at session start); MCP `.agents/mcp_config.json` (read from cwd);
  settings `.agents/hooks.json`; commands and skills under `.agents/skills/`. Resume
  rides a native workspace→conversation map file, not printed by `agy -p` — a
  dynamic, indirect surface like codex's hash file.

To measure kiro and antigravity for real, either provide the API-key / token their
container path needs, or extend the read-probe to the host (worktree) axis: strace
the engine running natively, where its keyring/sqlite auth already works. The host
axis needs `strace` installed on the host (today it lives only in the probe image)
and is a clean follow-up — as the launching parent we can trace them unprivileged
(`ptrace_scope=0` here), no container credential needed.

## Status

Measured live, real read-sets with ENOENT: **claude** (container), **opencode**
(container). Declared but not yet measured: **codex**, **kiro**, **antigravity**.
Blocked on container credentials (no mountable credential; host-axis probing is the
way in): **kiro**, **antigravity**. The read-observation capability itself is landed
and merged (`internal/lm/isolation/traceprobe.go`,
`container/seccomp/probe-seccomp.json`); the write-observation is the pre-existing
`docker diff` probe. This document is the working writeup; a blog post is a later
pass over it.
