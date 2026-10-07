---
tags:
  - tooling
  - ast-grep
  - refactoring
content_hash: sha256:1f3e4e168238f4462e08728ea90322d39246a0745a1d1265d636da18defe88b7
---
# ast-grep: Structural Code Search & Replace

## Meta-variable Syntax

| Syntax | Matches | Example |
|--------|---------|---------|
| `$VAR` | Single named AST node | `console.log($ARG)` |
| `$$$ARGS` | Zero or more nodes | `func($$$ARGS)` |
| `$_` | Wildcard (no capture) | `if ($_) { $$$_ }` |
| `$$VAR` | Unnamed nodes (punctuation) | `$$OP` matches `+` |

**Naming rules:** `$` + uppercase letters/underscores/digits (1-9). Invalid: `$lowercase`, `$123`, `$KEBAB-CASE`.

**Capture behavior:**
- Same name = must match identical code: `$A == $A` matches `x == x`, not `x == y`
- Prefix with `_` to suppress capture: `$_FUNC($_ARG)` matches any call with one arg
- Multi-node `$$$` is lazy—stops at first match of next pattern element

## Pattern Gotchas

**Pattern must be valid, parseable code.** Fragments won't work directly.

```yaml
# WRONG: "key": $VAL is not valid JSON
pattern: '"key": $VAL'

# RIGHT: Use context + selector
pattern:
  context: '{"key": $VAL}'
  selector: pair
```

**`kind` and `pattern` don't combine.** They're independent atomic rules. Use `context`/`selector` instead:

```yaml
# WRONG: trying to match field_definition with pattern
rule:
  kind: field_definition
  pattern: $NAME = $VAL

# RIGHT: use pattern object
rule:
  pattern:
    context: 'class A { $NAME = $VAL }'
    selector: field_definition
```

## Limitations

ast-grep does NOT support scope/type analysis, control/data flow analysis, finding undefined/unused variables, taint analysis, or constant propagation — these require semantic analysis beyond AST matching.