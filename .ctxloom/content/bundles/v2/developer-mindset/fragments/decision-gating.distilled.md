---
source_sha256: e7499c151f604004677909c566c60427aee73db92747a9f0c4234525393dc1a2
---
# Decision Gating

- Surface structural and interface decisions for sign-off before acting. The gate makes the decision visible; the user may approve or reject. Failure to avoid: deciding silently inside implementation.

## Gate these
- **Structural consolidation/splitting**: unifying separate launchers, packages, or modules; shared abstraction across independent units; splitting shared code apart. Changes *topology*, not just duplication.
- **Interface/seam changes**: public interface, trait, protocol, or extension seam where implementations plug in. Ripples to every implementation; gate at least as hard as topology.
- **Operator-control trades**: trading operator control for author convenience (e.g., one polymorphic launcher hosting many backends vs. discrete per-component launchers with full startup control).

## Don't gate
- DRY *within* a single unit (module, shared library).
- Local refactors that move no boundary and change no contract.

## Surfacing
- **In plans:** dedicated "Decisions for sign-off" section; each choice with 2–3 options. Never fold topology/interface/control decisions into step bullets.
- **Mid-implementation:** if an unplanned decision emerges, stop and ask; don't pick and proceed.
- **Default:** preserve existing separation and interface/seam contracts unless explicitly asked to change them. If unsure whether something crosses the line, treat it as a decision.
