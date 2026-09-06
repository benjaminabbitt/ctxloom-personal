---
tags:
  - coordinator
  - delegation
  - worktrees
notes: |
  Why: work produced under worktree/cell isolation has been silently
  lost — a relative path stays inside the sandbox, the worktree is
  pruned, and the loss surfaces only when a downstream agent is told
  to read a file that "does not exist" and rebuilds the work from
  scratch. The coordinator-hygiene rules exist because agents'
  claims of having written, archived, or cleaned up files have been
  observed false; the off-bus section exists because some harnesses
  spawn isolated agents with no publish channel at all, which
  inverts the rules — the return message becomes the only durable
  artifact, and a relative artifact path handed to such an agent is
  a black hole that reads as correct.
---
# Worktrees: artifacts must be PUBLISHED, not left in a sandbox

An agent under worktree/cell isolation has its own working directory.
Anything it writes to a RELATIVE path stays INSIDE that sandbox —
invisible to the coordinator, and destroyed when the worktree is
pruned. The loss surfaces late and expensively: a downstream agent is
told to read a file that "does not exist" and rebuilds the work from
scratch.

## Publish; do not work around

Write files wherever is natural in your working directory, then
**publish** them — `agent_report(publish_paths: [...])`, cell-local
relative paths, read and uploaded by the runner. That is how bytes
leave the sandbox; the coordinator pulls them with
`agent_fetch_artifact` (see the coordination-tools fragment).
`*.plan.md` in the session dir is auto-stamped on every report, so a
plan transmits for free — never paste or copy one by hand.

**File a SCOPE_FINAL report before finishing. The report IS the
deliverable.** Assume the coordinator cannot read your filesystem:
put the findings, numbers and verdict in the report body. "See the
report at <path>" is not a deliverable — it is a promise the sandbox
may not keep.

## When the agent is NOT on the bus

Some harnesses spawn worktree-isolated agents with no ctxloom agent
bus. Publishing is then unavailable and the rules invert:

- The coordinator MUST hand over **ABSOLUTE** artifact paths outside
  the worktree. Saying "artifacts go on /home" and then giving a
  relative `artifacts/...` path is the classic form of this bug: it
  reads as correct and is a black hole.
- The agent's **return message is the only durable artifact**.
- Some harnesses also refuse report-like files from a subagent's Write
  tool; write via shell heredoc instead.

## Coordinator hygiene

- Never trust "report written to X", "archived", or "cleaned up".
  `ls` it. These claims have been false.
- Before telling agent B to read agent A's output, VERIFY it exists —
  otherwise B silently rebuilds it.
- **Sweep worktrees before pruning.** They accumulate, are not removed
  when non-empty, and may hold the only copy of an agent's work.