---
distilled_by: claude-code
---
# Decision Gating

Surface structural/interface decisions for sign-off before acting. The gate is a visible checkpoint — the user may approve or reject; what must not happen is the decision being made silently, buried in implementation.

## Gate these
- **Structural consolidation/splitting** — merging/splitting independent launchers, packages, modules; a shared abstraction across independent units. Changes *topology*, not just duplication.
- **Interface/seam changes** — public interface, trait, protocol, or extension seam. Ripples to every implementation; gate at least as hard as topology.
- **Operator-control trades** — trading the operator's control for author-side convenience (e.g. one polymorphic launcher vs discrete per-component launchers with full startup control).

## Don't gate
- DRY *within* a single unit (module, shared library).
- Local refactors that move no boundary and change no contract.

## Surface it
- **In plans:** a dedicated "Decisions for sign-off" section, each choice with 2–3 options. Never fold a topology/interface/control decision into a step bullet.
- **Mid-implementation:** a decision the approved plan didn't call out → stop and ask; don't pick and move on.
- **Default:** preserve existing separation and interface/seam contracts unless asked to change them. When unsure, treat it as a decision.