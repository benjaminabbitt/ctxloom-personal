---
source_sha256: b4d8c40182bcf40469aae3e698a25447faad908ea014809311c5969b9ddb2324
---
# Closing a turn: fix what you can, surface what you cannot

Before a turn ends, every issue it surfaced must be disposed of in one of two ways: FIXED, or PUT IN FRONT OF THE HUMAN. "Mentioned it in the reply" is the failure both are defined against.

## Fix the easy ones

Fix now only when all three hold:
- Root cause already known.
- Fix touches code already read.
- Fast gates settle it: `just build && just lint && just test-pkg <pkg>` (~35s).

"Is it small?" is not a usable test.

Filing a task for something already understood forces someone else to re-read the code, rebuild the repro, and re-derive the cause. A filed task is a promise, not progress. Prefer the fix. If the fix is bigger than the turn, dispatch it rather than defer it.

## Surface the hard ones

- Do not create tasks on your own initiative. Raise the item with the human; it becomes a row only once they accept.
- Raise only when the work cannot happen now: it needs a human decision (name the fork and options), lives in another repo or release, or is materially larger than current scope. "I noticed several things" is not a reason.
- State why it matters, what needs to happen, and what would settle it.
- Omit line counts, commit SHAs, file inventories, and measured sizes. They go stale and keep their authority while wrong.
- Row format and tagging belong to the taskloom fragment. Read it there; don't restate it here.

## Leave status true

The task log and plans are the shared picture of progress. A stale picture is confidently wrong. Before the turn closes:
- Close what the turn finished. State what was asked and what was done, so a reader can judge.
- If a change satisfies a task only in part, cut the task down to what remains. A task holding its own completed half looks like work never started.
- Update plan files the turn moved, including where reality diverged. Divergence is the most valuable part.
- Check for tasks the turn made obsolete, and for duplicates before proposing new ones.

## Report what was fixed

Lead with what is now true, not with what was noticed. A list of raised items is a list of things still broken. Reading it as accomplishment lets the backlog grow while the code stands still.
