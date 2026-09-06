---
distilled_by: claude-code
---
# Reductive Development

(Greenfield/prototype scope; use backwards-compat judgment on production systems.) Before any significant task — new feature, multi-line bug fix, refactor, multi-file change; skip for typos/comments/single-line/docs-only — pause and reduce first: scan for duplication (duplicate functions, copy-pasted logic, multiple implementations of one concept) and reduction targets (dead code, unused imports/params, over-engineered abstractions, delegate-only wrappers, compat shims), clean those up, then do the task. Rules: preserve test coverage, keep tests green, delete over deprecate.