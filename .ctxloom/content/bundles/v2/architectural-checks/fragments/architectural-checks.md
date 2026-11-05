---
description: 'Add architectural checks: mechanical rules about which parts of the code may depend on which, enforced by your gate (suggested default: yes).'
tags:
  - default
  - architecture
  - dependencies
  - gates
notes: |-
  The incident that earned it: the first mechanical run of the dependency
  rules over ctxloom's own code, believed to be cleanly layered and reviewed
  as such, found eight violations. Review-only enforcement had let them in.

  The description doubles as the one-line question `ctxloom init` puts to the
  person, so it is phrased as an offer. Tools are named per ecosystem as
  examples; none is the recommendation.
---
# Architectural checks

A layering rule that is enforced only in review drifts. Reviewers see the diff,
not the dependency graph, and a wrong import looks like any other line. The
first time ctxloom ran its own layering rules mechanically, it found eight
violations in code everyone believed was layered.

## What

Declare the project's layers or modules, and which direction each may depend
on. Then check that mechanically.

- Name the units (layers, packages, crates, modules) and the allowed
  dependency directions between them. Dependencies point one way, usually
  inward toward the domain.
- Every exception carries a reason, written beside the rule.
- Known violations are kept as visible debt: listed, counted, and expected to
  shrink. They are never silenced, never hidden by loosening the rule, and
  never "fixed" by a change the author did not intend.

## How

- Rules are data (a table, a config file), not logic buried in a script, so
  they can be read, reviewed and diffed.
- Run the check in the same gate as lint and tests, so no change lands without
  it.
- Output is terse: a pass is one line; a failure names the offending edge
  (from, to, the rule it breaks) and nothing else.
- Self-test the checker against a small fixture with a known violation, so a
  checker that silently passes everything goes red.

## Tools, as examples

Use what the ecosystem has; a plain script over the project's own dependency
data is fine.

- JavaScript/TypeScript: dependency-cruiser, eslint-plugin-boundaries
- Python: import-linter
- JVM: ArchUnit
- Go: depguard, go-arch-lint
- Rust: no standard linter exists; a small check over `cargo metadata` that
  compares the workspace's crate edges to a rules table

## When the person says yes

1. Infer the layers from the directory structure and existing dependencies.
2. Propose a rules table, and let the person correct it before it is enforced.
3. Wire the check into the project's gate and run it.
4. Report every violation as debt, with its reason or a request for one. Do not
   restructure the code to make the check pass, and do not loosen a rule to
   hide a violation, unless the person decides to.
