---
distilled_by: claude-opus-5-5
---
# "Pre-existing" Is Not a Disposition

"Pre-existing" describes HISTORY, not what happens next: an observation, never a reason to move on. We own the tree — a red we did not cause is still a red we ship.

## Two valid responses
1. **Fix it** — preferred; the bar is a test, not an estimate: already root-caused + code already read + fast gates settle it = do it now
2. **Raise it with the human** — judgeable cold: what fails, how to reproduce, what you ruled out. You do not file it yourself; they decide if it becomes a row

NOT: "Noted, pre-existing, continuing", nor one mention in a report nobody re-reads.

## Verify before claiming
Asserted far more often than checked:
- `git log -S '<symbol>'` — when was this test/code introduced?
- `git log -- <path>` — touched by the current work, or anything landed today?

A failure in a test added hours ago is not pre-existing, however unfamiliar it looks. Check; the answer is often the opposite of the assumption.

## The trap
An intermittent failure in a package you didn't touch reads as someone else's problem — exactly when it gets waved through, reaches CI, and is dismissed again by someone else.

Default: **a red you cannot explain is yours until you have evidence otherwise.**

## Why
"Pre-existing" quietly converts an unexplained failure into someone else's backlog with nobody deciding to; triage is skipped, the finding lost, and the report still reads as diligent — dangerous, not merely lazy. Observed twice in one day: two independent agents labelled the same failing test "pre-existing and unrelated"; our own commit had introduced it hours earlier, and it was a real capture-integrity bug. Both reports careful, thorough, wrong in the same place.
