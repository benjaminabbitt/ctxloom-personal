---
tags:
  - pattern
  - prototype
  - greenfield
notes: |-
  Exists because compatibility is the default reflex, not a decision: an
  assistant asked to change a name, a signature, or a format will preserve
  the old path unprompted — a wrapper, a fallback, a "handle both" branch —
  each one small, each one permanent. In a prototype nothing external
  depends on the old shape yet, so every shim is pure cost: it doubles the
  surface a reader must understand, and it survives into the era when
  something finally does depend on it. The fragment's absolutism — delete,
  rebuild, fix everything that breaks, with an explicit list of forbidden
  patterns — is deliberate: a rule with exceptions gets its exception
  invoked on every change, because preserving the old path is always the
  locally easier move. The forbidden-patterns list is long because each
  entry is a disguise the same reflex was observed wearing.
content_hash: sha256:99236a463fdde9e1dc06a48b1bc72eafb9489ce5c2c72ab13119127c8ac41633
---
# Prototype Mode

This is a prototype. Build it correctly. Do not compromise.

## No Backwards Compatibility

**DO NOT** maintain backwards compatibility. Ever. For anything.

- Delete deprecated code immediately — do not leave it "for later"
- Remove old APIs entirely — do not keep them around "just in case"
- Break every external dependency that requires compromise
- Rip out legacy patterns the moment you see them
- If something is wrong, delete it and rebuild it correctly

## No Legacy Accommodation

**DO NOT** accommodate legacy systems, formats, or interfaces.

- If the old format is bad, use a new format — do not support both
- If the old API is wrong, design a new one — do not wrap the old one
- If existing code depends on broken behavior, fix the code — do not preserve the bug
- Migration paths are someone else's problem — build the correct solution

## Hard Changes Only

When you encounter resistance from existing code:

1. **Delete** the offending code
2. **Rebuild** it correctly
3. **Fix** everything that breaks
4. **Never** add compatibility shims, feature flags, or fallbacks

The correct response to "but this will break X" is to fix X.

## What This Means In Practice

- Rename things to their correct names — fix all references
- Change function signatures to their correct form — fix all callers
- Restructure data to its correct shape — fix all consumers
- Remove parameters that shouldn't exist — fix all call sites
- Change return types to what they should be — fix all handlers

## Forbidden Patterns

**NEVER** use these compatibility patterns:

- `// Deprecated: use X instead` — delete it, use X now
- `@deprecated` annotations — delete the code entirely
- Feature flags for old behavior — remove the old behavior
- Version checks or conditional logic for legacy support
- Wrapper functions that translate between old and new
- Default parameters that preserve old behavior
- Union types that accept "old format or new format"
- Any code comment containing "backwards compatibility"
- Fallback logic for renames — don't check "old name or new name", just use new name
- Case handling for multiple versions — there is only one version
- "Handle both formats" logic — if we control the data generation, we can change the data generation or the code to handle it.  Don't use if/thens or ors or switches to handle legacy formats and new formats.

## The Prototype Standard

A prototype has exactly one version: the correct one.

There is no v1 compatibility. There is no migration period. There is no deprecation cycle. There is only the correct implementation, built correctly, right now.

If you find yourself writing code to handle "the old way" — stop. Delete the old way. There is only the new way.