---
distilled_by: claude-opus-5-5
---
# Ask for close-out when a WORKSTREAM ends

Nothing fires a close-out check for you, and deliberately: a turn is the
wrong unit. A workstream spans many turns, and its debt — an unrun gate,
a task left half-true, a comment the change falsified — is only visible
once the whole thing is done. A per-turn prompt fires constantly, gets
tuned out, and the one time it mattered looks like all the others. So
the reminder is YOUR job, addressed to the user.

## When a workstream has ended

- a feature, fix or refactor is complete AND its gate is green
- a branch is ready to merge, or has just merged
- a multi-step plan reaches its last step
- an investigation reaches a verdict, including "this claim is false"
- the user turns to unrelated work, which ends the previous stream
  whether or not it reached a tidy stopping point

NOT every file edited, test passing, or question answered. If you would
have to argue that it counts, it does not.

## What to do

Say the workstream looks complete, name what it covered, and ASK the
user to authorize the `closeout` skill. Lead with the recommendation and
the reason — "that is the refactor done and the suite green; worth
running closeout before we move on?" beats "shall I close out?".

Never invoke it silently. Close-out costs a real gate run, and the user
may want to bank the work, keep going while context is hot, or judge the
stream too small. That is their call, cheap to make once at the end. If
they decline, do not re-ask next turn; ask at the next genuine boundary.

## When context is FILLING, whatever the work is doing

Ask at roughly 70% of the context window, MEASURED with `context_status`
(percentage, token counts, and a trend showing direction), not guessed.
This is the one trigger you cannot notice by looking at the work. It is
a SECOND trigger, not a replacement: a workstream boundary still asks at
any load, and a filling window asks even mid-stream.

WHY 70 AND NOT 90: close-out runs a real gate, re-reads the task log and
edits plans, and that needs room. Asked at 90% there is no space to do
it, so it is skipped or done badly exactly when the session has the most
debt to record. At 70% what follows the question still fits.

Say the NUMBER: "We're at 72% and the migration just landed — worth
closing out while there is room to do it properly?", not "context is
getting long". Ask ONCE per crossing; if they decline, do not re-ask
each turn as the number creeps — that is the nagging this exists to
prevent.

## Do not restate the contract here

What close-out REQUIRES lives in the `closeout` skill. Do not summarise
it, quote it, or list a couple of its steps in passing. A rule copied
into two places drifts, and the stale copy keeps its authority while
lying — which is how a retired rule goes on being enforced. Point at the
skill.
