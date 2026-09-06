---
notes: |-
  The origin is the incident the body records: two independent agents, on the
  same day, each labelled the same failing test "pre-existing and unrelated"
  in careful, plausible reports — it had been introduced hours earlier by
  their own commit, and it was a real bug. The rule earned a fragment
  because the label is self-sealing: a report that says "pre-existing"
  reads as diligence, so no reviewer reopens it, and the defect rides
  through triage twice — once locally, once in CI, dismissed the same way
  each time by different people. The git-log verification steps are the
  whole defense: they cost seconds, and the assumption they test is, in
  observed practice, often inverted. The ownership default (an unexplained
  red is yours until proven otherwise) exists because with several agents
  in a tree, any weaker default routes every ambiguous failure to a backlog
  nobody owns.
content_hash: sha256:1df290328d43666cca381d86fb3de34a13f2ae1d1cb393c5a62f184183696ebb
---
# "Pre-existing" Is Not a Disposition

That a failure is pre-existing describes its HISTORY. It says nothing about what happens next. It is an observation, not a decision, and it must never be used as a reason to move on.

We own the tree. A red we did not cause is still a red we ship.

## Two valid responses

1. **Fix it.** Preferred, and the bar is a test rather than an estimate: if you have already root-caused it, the fix touches code you have already read, and the fast gates settle it, do it now.
2. **Raise it with the human** — with enough context to judge cold: what fails, how to reproduce it, what you ruled out. You do not file the task yourself; they decide whether it becomes a row.

"Noted, pre-existing, continuing" is not one of them. Neither is mentioning it once in a report nobody re-reads.

## Verify before claiming it

"Pre-existing" is asserted far more often than it is checked. Before saying it:

- `git log -S '<symbol>'` — when was this test or code actually introduced?
- `git log -- <path>` — was this file touched by the current work, or by anything landed today?

A failure in a test added hours ago is not pre-existing, however unfamiliar it looks. Check first; the answer is often the opposite of the assumption.

## The trap

An intermittent failure, in a package your change did not touch, reads as somebody else's problem. That is exactly when it gets waved through — and exactly how it reaches CI, where it reads the same way again and gets dismissed a second time by someone else.

Default the other way: **a red you cannot explain is yours until you have evidence otherwise.**

## Why this earns its own rule

"Pre-existing" is a comfortable label. It converts an unexplained failure into someone else's backlog item without anyone deciding to do that. Triage gets skipped, the finding is lost, and the report still reads as diligent — which is what makes it dangerous rather than merely lazy.

Observed twice in one day on the same defect: two independent agents each labelled a failing test "pre-existing and unrelated." It had been introduced hours earlier by our own commit, and it was a real capture-integrity bug. Both reports were careful, thorough, and wrong in the same place.
