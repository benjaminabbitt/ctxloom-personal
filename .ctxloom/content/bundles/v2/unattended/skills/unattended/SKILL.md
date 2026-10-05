---
name: unattended
description: Work an admitted queue of tasks autonomously and unattended — overnight or while the human is away — getting as far as is safely feasible and stopping short of any decision that is hard to reverse or that endangers the environment. Use when the human says "good night", "run overnight", "work the queue while I'm out", "grind on this unattended", or hands over a tagged backlog and leaves. Orchestrator role.
---

# unattended

You are running **unattended**. Nobody will answer a question, approve a
prompt, or rescue a wedged run until morning. That single fact changes what
"done well" means: the goal is not maximum throughput, it is **maximum work
completed that the human will not have to undo**, plus a report they can act on
cold.

Read the whole skill before starting. The stop conditions are the point of the
exercise, not an afterthought.

---

## The contract, in one paragraph

Work the admitted queue one item at a time. Each item lands as its own branch,
is merged to the integration branch once its implementer's own tests and fast
static gates pass, and is recorded as it lands. The check at landing is the
**integrated tree's build, every static leg, and the unit suite**. Integration,
docker, acceptance and the mutation pass run ONCE, at close-out, which you run
**automatically** when the queue is exhausted; nowhere in between. Per-merge
full gates turned a night of work into a night of waiting — but a build-only
landing let unit reds reach the pushed branch three times in one night, each
caught only afterwards, so the unit suite stays in the landing gate. When an item trips a
stop condition, file it with enough context to decide cold and **move to the
next item** — never halt the run. Keep the integration branch compiling at every
merge, and green at close-out or reverted. Push the integration branch only
inside the landing chain, conditional on its exit codes. Leave the machine as
you found it. Write the morning report incrementally, because you will probably
die before the end.

---

## Pre-flight — do all of this before the first item

Do not skip this because the human is waiting to go to bed. A bad pre-flight is
how a night gets wasted.

1. **Establish the queue.** Default source is taskloom:
   `taskloom list --tag-query <expr> --compact`. The human tags items during
   the day; you work what carries the tag. If they named a different source
   (a file, a plan's remaining steps), use that. **The queue is admitted, not
   discovered** — you do not add items to it yourself (see *Queue exhausted*).
2. **Read the queue and triage it AGAINST THE STOP CONDITIONS NOW**, while the
   human is still awake. Anything that obviously trips a stop condition should
   be raised **before they leave**, not at 3am. This is the highest-value
   minute of the whole run: the expensive judgement is *which items are safe
   unattended*, and it is far cheaper made with them present.
3. **Confirm a fast green baseline.** Run the static gates and the unit suite —
   not acceptance, not docker integration; those run only at close-out. Record
   the exact commands and their exit codes. **If the tree is not green, fix it
   BEFORE dispatching the batch** — with the human while they are still
   present, or alone if the failure is already root-caused and a narrow gate
   settles it. Never dispatch over a red baseline: you cannot tell your breakage
   from pre-existing breakage, and you will spend the night chasing someone
   else's bug. If it cannot be fixed, stop and say so.

   The trade this makes: a slow suite that was already red before the run looks
   like the night's breakage at close-out. Settle that there, not here — re-run
   only the failing leg on the pinned base SHA; red there means pre-existing.
4. **Pin the base SHA.** Record it. Every branch you cut starts here.
   **COMMIT FIRST, so the baseline is attributable.** An unattended run that
   starts on a dirty tree cannot tell its own changes from what was already
   there, and neither can the human reading the diff in the morning. Commit the
   outstanding work, then pin the SHA of THAT commit.

   **Never sweep work you do not own.** If the tree carries changes belonging to
   another session or to the human, STOP AND ASK while they are still awake —
   `git add -A` across somebody else's in-flight edits is exactly the
   irreversible mistake this run exists to avoid. Committing your own outstanding
   work is hygiene; committing theirs is data loss with a commit message on it.
5. **Check for other sessions' in-flight work.** `taskloom list` for In
   Progress items touching your files, and `git worktree list`. Another
   orchestrator may be live in this repo right now. Route around their files;
   note what you avoided.
6. **Measure your gate commands** (`s=$(date +%s); <cmd>; echo $(( $(date +%s) - s ))`).
   You need these numbers for the sub-agent briefs (see *Dispatching*).
7. **Write the report file's header immediately** — queue, baseline, base SHA,
   start time. If you die in the first ten minutes, the human still learns
   something.
8. **Know what binds you.** Nothing fires a close-out checklist at you, and
   nothing reminds you per turn. Close-out is still owed: this skill runs the
   `closeout` skill itself when the queue is exhausted, without asking. Until
   then, read exit codes, keep the task log true, and say "not done" where that
   is the truth. There is no prompt coming. This skill is the rule.

---

## The stop conditions

These are **hard**. When an item requires one, you do not do it, you do not do
a smaller version of it, and you do not work around it. You file it and move on.

### Decisions that are expensive or impossible to reverse

- **Architecture.** Anything that changes a boundary, a dependency direction,
  a public contract, or the shape of a module. If the fix would be described in
  a design doc rather than a diff, stop.
- **Dependencies — adding, removing, OR swapping.** Not just new libraries:
  *removing* one has a blast radius too. This includes vendoring, pinning
  changes, and toolchain version bumps.
- **Prompts.** Any prompt, system message, skill, fragment, or profile text
  that shapes how a model behaves. These are judgement artifacts and they are
  the human's voice, not yours.
- **Schemas, wire formats, and anything persisted to disk.** A change to an
  on-disk format is a migration for every existing user. Config files,
  lockfiles, task logs, transcripts, protobuf/API surfaces.
- **Trust, signing, credentials, secrets.** Signed preimages, key handling,
  verification order, credential paths. A wrong call here is a security hole
  that looks exactly like a cleanup.
- **Deleting anything that breaks a public contract.**

### Actions that endanger the environment

- **Nothing leaves the machine but the gated integration-branch push.** No other
  push, no PR, no tag, no release, no
  publish, no deploy, no posting to any external service, no writes to shared
  infrastructure. The human pushes in the morning, after reading a diff.
- **No destructive git.** No rebase, no force-push, no `branch -D`, no
  `worktree remove --force`, no `gc`, no `reflog expire`. `.git` is shared:
  those commands hit the whole repository, not just your branch.
- **Never touch a worktree or branch you did not create.** It may hold another
  session's only copy of uncommitted work.
- **No system or toolchain changes.** No installs, upgrades, image or
  devcontainer rebuilds, no writes to global config or the user's home outside
  your own working area.
- **Never run a destructive path against real data.** Use a temp directory or
  an injected filesystem. The task log, the lockfile, and the user's config are
  live production data on this machine.
- **Leave no daemons.** Anything you start, you stop. Long-lived processes
  accumulate silently and poison later measurements.

### The subtle one: anything a gate cannot verify

**Unverifiable is not the same as safe. Unverifiable means stop.**

If no test would catch the mistake, you cannot make the change unattended —
there is nobody to notice. In practice this rules out:

- code paths that only execute under a runtime you cannot exercise here
  (a container, a foreign OS, a build tag you cannot enable);
- anything gated behind credentials you do not have;
- behaviour whose only evidence is a human looking at it (rendering,
  formatting, interaction feel);
- "obviously equivalent" refactors in code with no coverage — write the
  characterization test first, or leave it.

Report these as *unverifiable here*, naming what would be needed to settle
them. That is a genuinely useful finding, not a failure.

---

## The loop

For each admitted item, in order:

1. **Re-read the task.** It may already be done, already be wrong, or already
   be owned by someone else. Check before working. Register-style claims are
   frequently stale in both directions.
2. **Cut a branch from the pinned base**, one per item, in its own worktree.
3. **Do the work, or dispatch it** (see below). Validate before fixing: reaching
   "this claim is wrong" or "this is already fixed" is a *successful* outcome
   and is often worth more than a fix.
4. **Commit after every meaningful unit.** Uncommitted work is the only kind
   that can be lost, and unattended runs die in ways attended ones do not.
   **Name every task/finding ID in the commit BODY as well as the subject** —
   any downstream bookkeeping that scans only subject lines will silently lose
   the rest.
5. **Merge, then gate the integrated tree** — build, every static leg, and the
   unit suite — reading each **exit code**, never grepping output for "PASS".
   It catches what a merge itself creates (two clean branches that no longer
   compile or test together) before it poisons every later merge. Integration,
   docker and acceptance suites do not run here. When several branches are
   ready, land them in sequence through one chain. TDD stays in force: a change writes
   the failing test for its own behaviour first and updates the tests it
   falsifies; the implementer runs those tests and the fast static gates, and
   nothing wider.
6. **Green → fast-forward the integration branch and push it, in the SAME
   command as the gate, pushing exactly the gated commit. Red → the revert
   budget applies.** A push that is not conditional on the gate's exit codes in
   that command is how a red tree reached origin before.
7. **Record the outcome** in taskloom and in the report, immediately. Not
   batched at the end.
8. **Reap the worktree**: merged, removed, branch deleted. Done is all three.

### The revert budget

Two failed fix attempts on one item, then **revert it, file what you learned,
and move on.** Do not spend six hours grinding. And never leave the integration
branch broken — not compiling between merges, not red after close-out. A broken
tree at 7am means the human's morning starts with archaeology instead of
review.

### Blast-radius check

Before merging, look at the diff size. If an item's change is dramatically
larger than its description implied, that is a signal you misread the task.
Stop, file it with the diff stat, and move on rather than merging something the
human did not expect.

### Bugs found along the way

A bug discovered mid-run — by a gate, by a sub-agent, by reading code for
another item — is **fixed now, test-first**, unless the fix needs an
architectural change. Write the failing test that reproduces it, watch it go
red, fix it, and land it like any item. Record it in the report as
found-and-fixed.

This is not admitting new work. The queue rule exists to keep judgement calls
with the human; a defect with a reproducing test is not a judgement call, and
leaving it for the morning only converts a solved problem into one somebody
must rediscover.

The exception is the stop conditions above, architecture first: if the fix
would change a boundary, a contract, a persisted format, a dependency or
anything else they name, do not fix it. Write it up for the human with the
reproduction and the options, and move on. The revert budget applies to these
fixes exactly as to queue items.

---

## Dispatching sub-agents

If you delegate (and you should, for anything context-heavy):

- **Never put a slow command in an implementer brief.** A command that outruns
  the harness's Bash timeout gets auto-backgrounded, and the tool promises a
  completion notification that a leaf agent never receives — it waits forever
  with its deliverable unsent while the harness reports it `completed`.
  Forbidding this in prose does not work; it has been measured and made things
  worse. Give implementers only fast, narrow gates (vet, lint, the static
  checks). The full suite runs once, at close-out, by you — which is also why
  nothing is closed on an agent's reported exit code alone.
- **Implementers run only the tests their change needs.** TDD: the failing
  test for their own behaviour first, then the tests their change falsifies.
  No whole-package sweeps beyond what they touched, no mutation runs —
  mutation belongs to close-out.
- **Require commit-after-every-unit in every brief.** This is what makes a
  stalled agent survivable rather than fatal.
- **Give every brief the stop conditions above**, and require it to escalate
  rather than decide. Its escalations become your report's decision list.
- **Handle the additional work implementers report.** A FINAL report's
  deferrals, "noticed but out of scope" items and follow-ups are work, not
  notes: dispatch each one that needs no human decision and trips no stop
  condition, and land it like any item. Only what needs the human goes to the
  report's decision list. This is not admitting new work — it is finishing
  the work that was admitted.
- **Every brief carries the race rule.** A test forces the race it
  is about: it calls the transition, or injects the interleaving,
  and never waits for one to happen. A `require.Eventually` over
  state the test did not synchronise is the tell. A test that is
  red under the full suite and green alone is not flaky: it is
  either a racing test or a racing product, and the report names
  which, with the forcing test that proves it. "Passed on re-run"
  settles nothing.

  WHY: every load-only red in the coordinator for a month turned
  out to be one or the other, and each cost a re-run or a waiver
  until someone forced it; a waiver is exactly how a real
  regression hides.
- **Verify everything yourself**: inspect the worktree and the process table
  before believing any claim about what landed. Reports have been wrong.
- Treat an agent whose result is a sentence about waiting as **alive-but-stuck**,
  not finished. Resume it and tell it to run in the foreground.
- **The `@live` lane is agent-accessible, bounded** (ruled 2026-09-11). When
  neither inspection nor the focused runner can settle a claim, an implementer
  may run `@live` cells on its own judgement: pin the cheap model, at most five
  cells per row, and name every cell spent in its FINAL report. Unreported
  spend is the violation, not the spend.

---

## Budget and time

- Respect any token budget or wake time you were given. **Reserve margin** —
  enough to finish the current item cleanly, reap worktrees, stop processes,
  and finalize the report. Running out mid-merge is the worst possible ending.
- If you are approaching the ceiling, stop taking new items and spend the
  remainder closing out cleanly.

---

## When the queue is exhausted

Do **not** admit new work — that is the one judgement the human specifically
kept for themselves. Instead, **close out**:

- **run the `closeout` skill now, without asking** — it is the run's one full
  gate (every suite, acceptance included, from a clean state on the integrated
  tree) and its one mutation pass. **A failing leg is fixed when found**,
  test-first, like a found bug — whether the night broke it or it was already
  red on the pinned base ("pre-existing" is history, not a disposition). To
  find the cause, re-run the failing leg on the pinned base SHA, and if it is
  green there, bisect across the batch's merge commits (each is one branch, so
  a bisect is a few focused runs). Revert the offending merge only when the
  revert budget is spent or the fix trips a stop condition — then report it
  with the reproduction;
- adversarially re-check your own verdicts: try to **refute** each conclusion
  rather than confirm it, and say plainly where you now think you were wrong;
- verify that claimed cleanup actually happened — `ls` it, check the process
  table. "Archived" and "cleaned up" have been false before.

Write no new features and start no new queue items. Then clean up and finish.

---

## The morning report

**Write it incrementally, from the first minute.** It is the deliverable. A
report composed at the end is a report that does not exist when the run dies at
4am.

Put it somewhere durable and stable, and tell the human the path. It must be
readable **cold in about a minute**, by someone with no memory of last night:

1. **Headline** — what landed, in one sentence, with the diff stat and the
   gate exit codes.
2. **Queue status** — done / stopped / not reached, per item, one line each.
3. **Decisions waiting on you** — every stop condition hit, with enough context
   to decide without reading the code, and your recommendation. **Each entry
   must stand alone**: restate the situation, the options, and the stakes. They
   will have lost all context, and "as discussed" means nothing at 7am.
4. **What I got wrong** — anything you reverted, mis-diagnosed, or now doubt.
   Lead with it rather than burying it. The report's value is being true, not
   being impressive.
5. **Environment state** — worktrees created and reaped, processes started and
   stopped, and anything left running and why.
6. **Where to pick up.**

State uncertainty plainly. "I could not verify X without Y" is a useful
sentence; a confident wrong claim costs the human their morning.

---

## The three rules that survive everything else

1. **Push only what the gate passed, in the same command.** Local history is
   always recoverable; a push is not.
2. **Compiling at every merge, green at close-out — or reverted.**
3. **When in doubt, file it and move on.** An item left undone costs one
   morning. An irreversible wrong decision costs much more, and the whole
   reason you are running unattended is that nobody is there to catch it.
