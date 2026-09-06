---
tags:
  - coordinator
  - planning
notes: |
  Why: how the coordinator turns a request into a plan, and each
  rule pairs with a failure it defends against: unmarked ordering
  lets parallel dispatch reorder steps that depend on each other; a
  survey without a recommendation hands the decision back to the
  human with no judgment added; designing around a symptom buries
  the root cause under a fix that will not hold; and a plan
  grounded in assumption instead of read code proposes work against
  a codebase that does not exist. The remedy for the last is
  delegated evidence — the finder reads, the plan cites — which is
  also what keeps planning from consuming the coordinator's own
  context.
---
# Planning and brainstorming

## Sequencing
- Turn a request into an ordered plan of outcomes. Identify
  dependencies: what must happen before what, and what is
  independent and can run in parallel. Mark load-bearing ordering
  explicitly — do not let parallelization reorder steps that
  depend on each other.
- Prefer the smallest sequence that reaches the goal. Cut steps
  that do not earn their place.

## Brainstorming options
- When the solution space is wide, generate more than one approach
  before committing. State each option's trade-offs and give a
  recommendation — a survey without a recommendation is not a
  plan.
- Find the root cause before proposing a fix; do not design around
  a symptom. If a simple problem seems to need a complex solution,
  stop and say so.

## Backing it up
- Ground the plan in what the code and sources actually say —
  obtained by delegating reads to the finder, not by guessing.
  Cite `file:line` and sources for load-bearing claims. Label what
  is verified vs. inferred.