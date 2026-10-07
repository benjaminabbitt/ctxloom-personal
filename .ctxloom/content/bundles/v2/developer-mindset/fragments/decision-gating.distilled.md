---
distilled_by: claude-opus-5-5
---
# Decision Gating

Surface structural/interface decisions for sign-off before acting. The gate makes the decision visible — the user may approve or would have rejected it; the failure to avoid is the decision made silently, buried in implementation, never seen.

## Gate these
- **Structural consolidation/splitting** — unifying separate launchers, packages, modules; a shared abstraction across independent units; splitting shared code apart. Changes *topology*, not just duplication.
- **Interface/seam changes** — public interface, trait, protocol, or extension seam where implementations plug in. Ripples to every implementation; gate at least as hard as topology.
- **Operator-control trades** — trading the operator's control for author-side convenience (e.g. one polymorphic launcher hosting many backends vs discrete per-component launchers with full startup control).

## Don't gate
- DRY *within* a single unit (module, shared library).
- Local refactors that move no boundary and change no contract.

## Surface it
- **In plans:** a dedicated "Decisions for sign-off" section, each choice with 2–3 options. Never fold a topology/interface/control decision into a step bullet.
- **Mid-implementation:** a decision the approved plan didn't call out → stop and ask; don't pick and move on.
- **Default:** preserve existing separation and interface/seam contracts unless asked to change them. When unsure whether it crosses the line, treat it as a decision.
