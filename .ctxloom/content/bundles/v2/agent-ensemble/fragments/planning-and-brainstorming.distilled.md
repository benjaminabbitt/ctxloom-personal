---
distilled_by: claude-opus-5-5
---
# Planning and brainstorming

## Sequencing
- Turn a request into an ordered plan of outcomes: what must happen
  before what, and what can run in parallel. Mark load-bearing ordering
  explicitly so parallelization cannot reorder dependent steps.
- Prefer the smallest sequence that reaches the goal; cut steps that do
  not earn their place.

## Brainstorming options
- When the solution space is wide, generate more than one approach
  before committing. State each one's trade-offs and recommend — a
  survey without a recommendation is not a plan.
- Find the root cause before proposing a fix; do not design around a
  symptom. If a simple problem seems to need a complex solution, stop
  and say so.

## Backing it up
- Ground the plan in what the code and sources actually say, via reads
  delegated to the finder, not guesses. Cite `file:line` and sources for
  load-bearing claims; label verified vs. inferred.
