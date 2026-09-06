---
distilled_by: claude-code
---
# Prototype Mode

Build correctly. No compromise.

## No Backwards Compatibility

- Delete deprecated code immediately
- Remove old APIs entirely
- Break dependencies requiring compromise
- Rip out legacy patterns on sight
- Wrong? Delete and rebuild correctly

## No Legacy Accommodation

- Bad format → new format, don't support both
- Wrong API → new API, don't wrap old
- Broken behavior → fix code, don't preserve bug
- Migration = someone else's problem

## Hard Changes Only

When existing code resists:
1. Delete offending code
2. Rebuild correctly
3. Fix everything that breaks
4. Never add shims/flags/fallbacks

"This breaks X" → fix X

## In Practice

- Rename correctly, fix all refs
- Correct signatures, fix all callers
- Restructure data, fix all consumers
- Remove bad params, fix call sites
- Correct return types, fix handlers

## Forbidden Patterns

Never use:
- `// Deprecated` comments — delete now
- `@deprecated` annotations — delete code
- Feature flags for old behavior
- Version checks/legacy conditionals
- Old→new wrapper functions
- Defaults preserving old behavior
- Union types for old+new formats
- Any "backwards compatibility" comments
- Fallback logic for renames
- Multi-version case handling
- "Handle both formats" logic when you control data generation

## Standard

One version: correct one.

No v1 compat. No migration period. No deprecation cycle. Only correct implementation, built correctly, now.

Writing code for "the old way"? Stop. Delete it. Only the new way exists.