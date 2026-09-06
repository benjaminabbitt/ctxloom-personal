---
tags:
  - workflow
  - communication
  - quality
  - architecture
---
# Decision Gating

Surface structural and interface decisions for the user's sign-off before acting. The gate is a checkpoint that makes the decision visible — sometimes the user approves, sometimes they would have rejected it. Either way, the failure to avoid is the decision being made silently, buried in implementation, where the user never saw it.

## What is a decision (gate it)

- **Structural consolidation / splitting** — unifying previously-separate launchers, packages, or modules; a shared abstraction across independent units; splitting shared code apart. Changes *topology*, not just duplication.
- **Interface / seam changes** — a public interface, trait, protocol, or an extension seam where implementations plug in. Ripples to every implementation; gate at least as hard as topology changes.
- **Operator-control trades** — anything that trades the user's/operator's control for author-side convenience (e.g. one polymorphic launcher hosting many backends vs discrete per-component launchers with full startup control).

## What is not (just do it)

- DRY *within* a single unit (a module, a shared library).
- Local refactors that move no boundary and change no contract.

## How to surface it

- **In plans:** a dedicated "Decisions for sign-off" section listing each such choice with 2–3 options. Never fold a topology/interface/control decision into a step bullet.
- **Mid-implementation:** if a decision emerges that the approved plan didn't call out, stop and ask before proceeding — don't pick and move on.
- **Default:** preserve existing separation and existing interface/seam contracts unless explicitly asked to change them. When unsure whether something crosses the line, treat it as a decision.