---
tags:
  - code
  - quality
  - refactoring
notes: |-
  A counterweight to the additive default: every task tends to add code,
  and cleanup never happens on its own because it never becomes anyone's
  task. Binding reduction to the START of significant work is the whole
  mechanism — that is the one moment someone is already reading the area
  with intent to change it, so duplication and dead weight are visible at
  no extra cost, and the change then lands on a smaller, cleaner base. The
  significance threshold exists so the rule does not tax typo-sized edits
  into ceremony. The greenfield scoping caveat in the opening line is
  load-bearing, not hedging: the same aggression applied to a production
  API with external consumers is a breaking change, not a cleanup.
content_hash: sha256:b82c3a5f0f2d8d16f29d66cdb0957fe17cc91d83a2e83f52d26a993b711ea1a3
---
# Reductive Development

For greenfield/prototype projects where aggressive cleanup is acceptable; on production systems with external consumers, use judgment about backwards compatibility.

Before starting any significant task, reduce the codebase first.

## Pre-Task Reduction

1. **Pause before implementing** - do not start the task immediately
2. **Scan for duplication** - duplicate functions/methods, similar patterns to consolidate, copy-pasted logic to extract, multiple implementations of one concept
3. **Identify reduction opportunities** - dead code, unused imports/variables/parameters, over-engineered abstractions, delegate-only wrappers, compatibility shims for removed features
4. **Reduce first** - clean up what you find before starting the actual task
5. **Then proceed** on the smaller, cleaner codebase

## Reduction Rules

- **Preserve coverage**: do not reduce code in ways that meaningfully reduce test coverage
- **Keep tests passing**: all reductions must leave the suite green
- **Small is better**: smaller codebases are easier to understand, modify, maintain
- **Delete over deprecate**: remove unused code entirely rather than marking it deprecated

## What Counts as Significant

Apply for: new features, bug fixes requiring more than a few lines, refactoring tasks, any change touching multiple files.

Skip for: typo fixes, comment updates, single-line changes, documentation-only changes.