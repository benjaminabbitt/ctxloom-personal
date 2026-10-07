---
distilled_by: claude-code
---
# ast-grep

Meta-variables: `$VAR` one named node; `$$$ARGS` zero+ nodes (lazy — stops at next pattern element); `$_` wildcard, no capture; `$$VAR` unnamed nodes (punctuation). Names: `$` + uppercase/underscores/digits 1-9. Same name must match identical code (`$A == $A` matches `x == x` only); `_`-prefix suppresses capture.

Gotchas:
- Patterns must parse as valid code — a fragment like `'"key": $VAL'` fails; wrap it: `pattern: {context: '{"key": $VAL}', selector: pair}`.
- `kind` and `pattern` are independent atomic rules; they don't combine. Use a pattern object with `context`/`selector` (e.g. context `'class A { $NAME = $VAL }'`, selector `field_definition`).

No scope/type analysis, control/data flow, undefined/unused-variable detection, taint analysis, or constant propagation — AST matching only.