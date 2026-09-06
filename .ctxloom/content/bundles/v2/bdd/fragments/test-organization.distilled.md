---
distilled_by: claude-code
---
# Test Organization

Tests live next to the code — same directory, separate clearly-named file (`.test.rs`, `_test.go`); not inline (contra the Rust default), not a parallel tree.

Rust wiring (test module vanishes from release builds):

```rust
#[cfg(test)]
#[path = "correlation.test.rs"]
mod correlation_tests;
```

Location by type: unit and BIT (Behavioral Interface Test — implementation against its interface's behavioral contract) in the adjacent `.test` file; integration (multiple components) in `tests/`; E2E in a separate test project; shared fixtures in `src/test_utils/`, not a parallel tree. Colocation is the default — don't separate without reason.