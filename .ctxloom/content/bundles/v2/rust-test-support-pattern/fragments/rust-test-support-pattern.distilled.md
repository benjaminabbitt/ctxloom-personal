---
distilled_by: claude-code
---
# Rust Test Support File Pattern

Keep test-only code out of production files: in foo.rs add `#[cfg(test)] #[path = "foo_test_support.rs"] pub(crate) mod test_support;` and put helpers in sibling `foo_test_support.rs`; tests.rs imports via `super::foo::test_support::...`. Visibility: `pub(super)` if only the parent module needs access, `pub(crate)` if sibling test modules do. Use when production code needs conditional test behavior, helpers exceed ~20 lines, or you want to cut context load reading production code; skip for tiny `#[cfg(test)]` helpers (<10 lines) or test code never called from production — plain `foo.test.rs` covers pure unit tests.