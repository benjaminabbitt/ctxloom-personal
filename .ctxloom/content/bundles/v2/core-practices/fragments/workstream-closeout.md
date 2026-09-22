---
tags:
  - workflow
  - quality
  - practices
---
# Ask for close-out when a WORKSTREAM ends

Nothing fires a close-out check for you. There is no turn-end hook, and its
absence is deliberate rather than an oversight: a turn is the wrong unit. One
workstream spans many turns, and the debt it accrues — an unrun gate, a task
left half-true, a comment the change falsified — is only visible once the
whole thing is done. A per-turn prompt fires constantly, says nothing useful,
and gets tuned out; the one time it mattered, it looks like all the others.

So the reminder is YOUR job, and it is addressed to the user.

## When a workstream has ended

- a feature, fix or refactor is complete AND its gate is green
- a branch is ready to merge, or has just merged
- a multi-step plan reaches its last step
- an investigation reaches a verdict, including "this claim is false"
- the user turns to unrelated work, which ends the previous stream whether or
  not it reached a tidy stopping point

NOT: every file edited, every test passing, every question answered. If you
would have to argue that it counts, it does not.

## What to do

Say the workstream looks complete, name what it actually covered, and ASK the
user to authorize the `closeout` skill. Lead with the recommendation and the
reason, not a bare question — "that is the refactor done and the suite green;
worth running closeout before we move on?" beats "shall I close out?".

Do not invoke it silently. Close-out costs a real gate run, and the user may
want to bank the work, keep going while context is hot, or judge that the
stream was too small to warrant it. That is their call, and it is cheap for
them to make once at the end.

If they decline, do not re-ask on the next turn. Ask again at the next genuine
workstream boundary.

## When context is FILLING, whatever the work is doing

Ask at roughly 70% of the context window, and MEASURE it rather than guessing —
`context_status` returns the percentage, the token counts, and a trend so the
DIRECTION is visible. A hunch about how long a session feels is not a number,
and this is the one trigger you cannot notice by looking at the work.

This is a SECOND trigger, not a replacement. A workstream boundary still asks
whatever the load is; a filling window still asks even mid-stream.

WHY 70 AND NOT 90. A close-out is not free — it runs a real gate, re-reads the
task log, and edits plans. That work needs room to happen in. Asked at 90%
there is no longer space to DO it, so the close-out is either skipped or done
badly at exactly the moment the session has the most accrued debt to record.
70% is chosen so that what follows the question still fits.

Say the NUMBER when you ask. "We're at 72% and the migration just landed —
worth closing out while there is room to do it properly?" gives the user
something to decide with; "context is getting long" does not.

Ask ONCE per crossing. If they decline, carry on and do not re-ask each turn as
the number creeps — that is the nagging this fragment exists to prevent.

## Do not restate the contract here

What close-out actually REQUIRES lives in the `closeout` skill. Do not
summarise it, quote it, or "helpfully" list a couple of its steps in passing.
A rule copied into two places drifts, and the stale copy keeps its authority
while lying — which is how a retired rule goes on being enforced. Point at the
skill; let it speak for itself.