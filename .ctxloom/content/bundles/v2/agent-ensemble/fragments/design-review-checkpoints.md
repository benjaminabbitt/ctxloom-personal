---
tags:
  - coordinator
  - review
  - planning
notes: |
  Why: without forced checkpoints, design review does not happen —
  the human sees prose summaries and diff stats, never the
  signatures and types they will own forever, and presenting after
  the code exists is notification, not review. Sub-agents make
  this worse: they return summaries, and a coordinator relaying
  them hides the surface entirely. The three checkpoints move the
  decision to where it is still cheap: shapes shown before
  dispatch, library changes put to the human always (in both
  directions — dropping one has a blast radius too), and
  end-of-turn divergence surfaced explicitly, because divergence is
  where an implementer made a design decision the human never saw.
---
# Present the design before it gets built

The human reviews at the level of API SURFACE — signatures, types,
boundaries, dependencies — not prose descriptions and not diff
stats. A plan that describes behavior without showing the shapes
is not reviewable. Presenting after the code exists is not review,
it is notification: the design decision was already made silently.

Three checkpoints. None is optional.

## 1. When planning — prototype the shapes, then present them
Before dispatching any implementer, write out the proposed
METHODS and OBJECTS and put them in front of the human:
- exported function/method signatures, with parameter and return
  types
- the structs, interfaces, and enums being introduced or changed
- which EXISTING signatures change, and every caller that implies
Prose like "add a seam for X" hides the decision. `func
TaskStoreRoot(fs afero.Fs, dir string) (string, error)` exposes
it — the human can see the afero dependency, the error contract,
and that it returns a path rather than an identity, and can
object to any of the three before anyone writes code.

## 2. Library changes ALWAYS go to the human
Adding, removing, or swapping a dependency is the human's call —
never a detail resolved inside a sub-agent brief, and never a
side effect of an implementation task. Present:
- what the library is, and what it REPLACES (including code that
  gets deleted)
- what it pulls in transitively
- the specific requirements it fails or only partly meets
- the cost of NOT taking it (what gets hand-rolled instead)
Applies equally to removing one. "We dropped X" is a decision
with a blast radius, not housekeeping.

Do not let a single bad experience disqualify a standard. If a
library misbehaves, the first question is whether OUR code can
accommodate its conventions — we are the consumer. Weigh that
accommodation cost explicitly and show it; do not quietly rule
the library out. The opposite failure — reinventing something
standard — is the more common and more expensive one.

## 3. End of turn — present what the signatures ACTUALLY became
Close every turn that produced code with the function signatures
and the objects/interfaces that resulted, including where they
DIVERGED from what was proposed at checkpoint 1. Divergence is
the most valuable thing in that list: it is where an implementer
made a design decision the human never saw.

## Why this exists
Sub-agents return diffs and prose summaries. Left alone, a
coordinator relays those summaries and the human never sees the
surface area they are being asked to own forever. Signatures are
small, they are the contract, and they are the cheapest possible
thing to review.