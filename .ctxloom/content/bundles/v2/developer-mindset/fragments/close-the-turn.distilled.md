---
distilled_by: claude-opus-5-5
---
# Closing a turn: fix what you can, surface what you cannot

Before a turn ends, every issue it surfaced is DISPOSED OF: you FIXED
it, or you PUT IT IN FRONT OF THE HUMAN. "Mentioned it in the reply" is
the failure both are defined against.

## Fix the easy ones — the bar is a test, not an estimate

DO IT NOW when all three hold: you have ALREADY root-caused it, the fix
touches code you have ALREADY read, and the fast gates settle it
(`just build && just lint && just test-pkg <pkg>`, roughly 35 seconds).
"Is it small?" is not a test — nobody calibrates it the same way twice.

Filing a task for something you understand and could fix this turn
converts a solved problem into work someone pays to rediscover: re-read
the code, rebuild the reproduction, re-derive the cause. A filed task is
a promise, not progress. Prefer the fix; where it is larger than the
turn, dispatch it rather than defer it.

## Surface the hard ones — do not file them yourself

Do not create tasks on your own initiative. RAISE the item; the human
decides whether it becomes a row, created once they accept. That keeps
the previous rule honest: an agent that files freely turns every
observation into a row, and the open pile grows as large as everything
ever completed.

Raise only when the work genuinely cannot happen now: it needs a HUMAN
DECISION (name the fork and the options), lives in another repository or
release, or is materially larger than the current scope. "I noticed
several things" is not a reason.

Say WHY IT MATTERS, WHAT NEEDS TO HAPPEN, and WHAT WOULD SETTLE IT.
Leave out line counts, commit SHAs, file inventories and measured sizes:
they go stale and keep their authority while lying. How an agreed row is
written and tagged belongs to the taskloom fragment.

## Leave the status TRUE

The task log and plans are the shared picture of where things stand; a
stale one is worse than none because it is confidently wrong. Before the
turn closes:

- Close what the turn finished, stating what was asked and what was
  done, so a reader can judge rather than take your word.
- Where a task is satisfied only in PART, cut it to what REMAINS; a task
  carrying its completed half is indistinguishable from work never
  started.
- Update the plan files the turn moved, including where reality diverged
  from the plan — the most valuable thing in them.
- Check for tasks the turn quietly obsoleted, and for duplicates you may
  create by proposing before reading.

## Report what was FIXED

Lead with what is now true, not what was noticed. A list of raised items
is a list of things still broken; reading it as accomplishment is how a
backlog grows while the code stands still.
