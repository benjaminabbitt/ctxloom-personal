---
source_sha256: a376ec3af396353a14a3be7807858d0d36ad1f5e6b3620bc8e7a3c5677cfe143
---
# Rust Test Support File Pattern

- Keep test-only code out of production files via `#[path]` include of a separate support file.
- Layout:
  - `foo.rs`: production code
  - `foo_test_support.rs`: test helpers
  - `tests.rs`: unit tests
  - `mod.rs`
- Production `foo.rs` (4 lines of boilerplate):
  ```rust
  #[cfg(test)]
  #[path = "foo_test_support.rs"]
  pub(crate) mod test_support;
  ```
  - Production logic may branch: `#[cfg(test)] if needs_test_handling { return test_support::test_handler(); }`
- `foo_test_support.rs`: starts with `//!` doc comment noting it is compiled only in tests via `#[path]`; holds helpers such as `pub(crate) fn test_handler() -> HashSet<String>`.
- `tests.rs`: `use super::foo::test_support::test_handler;`

## Visibility

| Visibility | Use when |
|---|---|
| `pub(super)` | Only parent (`foo.rs`) needs access |
| `pub(crate)` | Sibling modules (`tests.rs`) also need access |

## Use when
- Production code needs conditional test behavior
- Test helpers are substantial (>20 lines)
- Minimizing context load when reading production code

## Don't use when
- Simple `#[cfg(test)]` constants or small helpers (<10 lines)
- Test code not called from production code
- Pure unit tests: use `foo.test.rs` pattern instead
