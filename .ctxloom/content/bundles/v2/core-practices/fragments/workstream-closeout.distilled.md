---
source_sha256: 87fc51e3272440f4c26a07eaacd8257e6ea9f0e4e752105222f644ffd74eac16
---
# Ask for close-out when a WORKSTREAM ends

- No turn-end hook fires close-out checks, by design: a turn is the wrong unit. A workstream spans many turns, and its debt (unrun gate, half-true task, falsified comment) shows only at completion. Per-turn prompts fire constantly, get ignored, and the one that matters looks like the rest.
- The reminder is YOUR job, addressed to the user.

## When a workstream has ended
- Feature, fix or refactor is complete AND its gate is green
- Branch is ready to merge, or has just merged
- Multi-step plan reaches its last step
- Investigation reaches a verdict, including "this claim is false"
- User turns to unrelated work, which ends the previous stream whether or not it reached a tidy stop

NOT: every file edited, test passing, or question answered. If you would have to argue that it counts, it does not.

## What to do
Say the workstream looks complete, name what it covered, and ASK the user to authorize the `closeout` skill. Lead with the recommendation and reason, not a bare question: "refactor done and suite green; worth running closeout before we move on?" beats "shall I close out?"

Never invoke it silently. Close-out costs a real gate run, and the user may want to bank the work, keep going while context is hot, or judge the stream too small. That is their call, cheap to make once at the end.

If they decline, don't re-ask next turn. Ask again at the next genuine workstream boundary.

## When context is FILLING, whatever the work
- Ask at roughly 70% of the context window, and MEASURE it: `context_status` returns the percentage, token counts and a trend. A hunch is not a number.
- This is a SECOND trigger, not a replacement. A workstream boundary still asks whatever the load, and a filling window still asks mid-stream.
- Why 70, not 90: close-out runs a real gate, re-reads the task log and edits plans, so it needs room. At 90% it is skipped or done badly when the most debt has accrued. At 70%, what follows the question still fits.
- Say the NUMBER: "We're at 72% and the migration just landed; worth closing out while there is room?" beats "context is getting long".
- Ask ONCE per crossing. If they decline, carry on and don't re-ask as the number creeps.

## Don't restate the contract here
What close-out requires lives in the `closeout` skill. Don't summarise, quote or list its steps, even in passing. A copied rule drifts, and the stale copy keeps its authority while lying. Point at the skill.
