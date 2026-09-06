---
tags:
  - workflow
  - quality
notes: |-
  Defends against the most polished failure a work session has: the closing
  report that mentions every problem and disposes of none. A finding named in a
  reply feels handled — it was communicated — but nothing downstream reads
  replies, so the issue is lost the moment the session ends. Hence the
  fragment's central claim that there are exactly two honest dispositions,
  fixed or surfaced-to-the-human, and "mentioned it" is neither. Filing is
  deliberately NOT one of them: an agent that files on its own initiative
  turns every observation into a row, which is how the open pile grew to
  the size of everything ever completed. The
  status-hygiene half exists for the complementary failure: a task log that is
  only mostly true is worse than none, because the stale entries read with
  exactly the same authority as the live ones — a task carrying its completed
  half looks identical to work never started, and a closed-but-unrecorded fix
  gets done twice.
---
# Closing a turn: fix what you can, surface what you cannot

Before a turn ends, every issue it surfaced has to be DISPOSED OF. There
are exactly two honest dispositions — you FIXED it, or you PUT IT IN
FRONT OF THE HUMAN — and "mentioned it in the reply" is the failure both
of them are defined against.

## Fix the easy ones — the bar is a test, not an estimate

DO IT NOW when all three hold: you have ALREADY root-caused it, the fix
touches code you have ALREADY read, and the fast gates settle it
(`just build && just lint && just test-pkg <pkg>`, roughly 35 seconds).
That is a test you can actually apply. "Is it small?" is not — nobody
calibrates that the same way twice.

Filing a task for something you already understand and could correct in
the same turn converts a solved problem into work someone pays to
rediscover: they must re-read the code, rebuild the reproduction, and
re-derive the cause you already had in hand.

A filed task looks like progress. It is not progress; it is a promise.
Prefer the fix, and where the fix is larger than the turn, dispatch it
rather than defer it.

## Surface the hard ones — do not file them yourself

You do not create tasks on your own initiative. RAISE the item with the
human and let them decide whether it becomes a row; it is created once
they accept. That is what keeps the previous rule honest — an agent that
files freely turns every observation into a row, and the open pile is
now as large as everything ever completed.

Raise it only when the work genuinely cannot happen now: it needs a
HUMAN DECISION (name the fork and the options), it lives in another
repository or release, or it is materially larger than the current
scope. Those are real reasons. "I noticed several things" is not.

Say WHY IT MATTERS, WHAT NEEDS TO HAPPEN, and WHAT WOULD SETTLE IT.
Leave out line counts, commit SHAs, file inventories and measured sizes:
they go stale and then keep their authority while lying. How a row is
written and tagged once one is agreed belongs to the taskloom fragment —
read it there rather than restating it here.

## Leave the status TRUE

The task log and the plans are the shared picture of where things stand,
and a stale picture is worse than none because it is confidently wrong.
Before the turn closes:

- Close what the turn actually finished, stating what was asked for and
  what was done, so a reader can judge rather than take your word.
- Where a change satisfies a task only in PART, cut the task down to what
  REMAINS. A task carrying its own completed half is indistinguishable
  from work never started.
- Update the plan files the turn moved, including where reality diverged
  from the plan. The divergence is the most valuable thing in them.
- Check for tasks the turn quietly obsoleted, and for duplicates you may
  be about to create by proposing before reading.

## Report what was FIXED

Lead with what is now true, not with what was noticed. A list of things
you raised is not a status report: it is a list of things still broken,
and reading it as accomplishment is how a backlog grows while the code
stands still.