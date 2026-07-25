---
name: probe-engine-surfaces
description: Reverse-engineer where a vendor LLM CLI reads context and what it writes by tracing it in a container. Use when integrating a new engine, debugging silent context non-delivery, or checking that ctxloom materializes files where the CLI actually looks.
---

# Probe engine surfaces

To know what files a vendor coding-agent CLI reads, writes, or looks for — not from
its docs, which are never complete, but from the binary itself — trace it running in
a container. The failures are the payoff: a path the CLI looks for and does not find
(`ENOENT`) is a specification of where it will accept context, read off the binary
with no vendor documentation.

## When to use

- Integrating a new engine and you need its real config/context contract.
- A run succeeds but delivers no context (the silent no-op) — verify ctxloom writes
  where the CLI actually reads.
- Checking an engine's surface declaration against measured behavior before trusting
  it.

## The three planes

1. **Writes** — `docker diff` on the running container (writable-layer delta;
   write-only, so it can't see where the CLI looked).
2. **Reads** — `strace` via a probe-only seccomp profile: `openat`/`stat`/`access`
   and friends, including the `ENOENT` failures. This is the plane that matters.
3. **Tool calls** — the transcript's `tool_use`/`tool_result` entries (what the
   agent invoked, distinct from what its process read).

## Steps

1. Run `just isolation-probe <engine> container`. It drives the real credentialed
   engine through the production container path and reports the read-set and
   write-set. Engines: `claude-code`, `codex`, `kiro`, `opencode`, `antigravity`.
   One paid engine call per cell — keep it to one.
2. Read the read-set. The `ENOENT` rows are the map: every path the CLI probed and
   did not find is a place it would have accepted context. Group them — instruction
   files (`CLAUDE.md`/`AGENTS.md`/`CONTEXT.md`), settings, MCP config, command/skill
   dirs, credential paths.
3. Cross-check against what ctxloom materializes for that engine (its surface
   declaration). A path the CLI reads that ctxloom does not write is a delivery gap.
   A file ctxloom writes that the CLI never reads is wasted work — the silent no-op.

## Interpreting the result

- `ENOENT` is signal, not noise. Directory-hierarchy walks (project → `/tmp` →
  `/etc`) and managed-policy layers (`/etc/<engine>/managed-*`) appear only as
  `ENOENT`; `docker diff` can never show them because the CLI wrote nothing.
- A missing transcript file (`~/.ctxloom/sessions/<harp>/persist/transcript.jsonl`)
  means zero events — the engine produced nothing, itself a failure signal.

## Gotchas

- The read-observation is Linux-and-container only (strace + seccomp). **Discovery
  is Linux-bound; delivery is portable** — once you know the paths, materializing at
  them works on any OS.
- Some engines cannot authenticate in a container because their credential is not
  mountable: kiro keeps it in a sqlite store, antigravity in the OS keyring. Those
  need an API-key/token env var, or host-axis tracing. Claude and codex mount host
  creds on Linux.
- The seccomp profile allows the `ptrace` family WITHOUT the `SYS_PTRACE` capability,
  and it is applied only when `RunSpec.Trace != nil` — never on a production run.
  Do not reach for `--cap-add=SYS_PTRACE`; it is a larger privilege change than
  needed and it alters the isolation you are trying to measure.

## Dependencies

- Docker or Podman; `strace` in the probe image (base tool layer); the probe-only
  seccomp profile (`container/seccomp/probe-seccomp.json`); a credentialed engine.
- Code: `internal/lm/isolation/traceprobe.go` (read-set parse + RunSpec seam),
  `tests/acceptance/isolation_probe.go` (the probe harness and `docker diff` watch).

The full methodology — the security reasoning behind the seccomp choice, the
host-side and runtime interception options, cross-platform notes, and the measured
per-engine read-sets — is in `references/methodology.md` in this skill package.
