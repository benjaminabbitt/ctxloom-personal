---
tags:
  - testing
  - organization
  - colocation
  - patterns
content_hash: sha256:da002e5995f86a8e9eea936d2a4f56e94806e1c464e6c29f8153c28e2e2c6f75
---
# Test Organization

Tests belong next to the code they test — same directory, separate file, clearly named (`.test.rs`, `_test.go`). Not inline (contra the Rust default), not in a parallel tree.

```
src/
├── user_service.rs           # Production code only
├── user_service.test.rs      # Tests only
└── mod.rs
```

## Rust Mechanics

```rust
// correlation.rs — production code only
pub struct Correlation { /* ... */ }

// mod.rs
pub mod correlation;

#[cfg(test)]
#[path = "correlation.test.rs"]
mod correlation_tests;
```

In release builds the test module doesn't exist — not compiled, not linked, not present.

## Test Type by Location

| Test Type | What It Tests | Where It Lives |
|-----------|--------------|----------------|
| Unit | Pure logic, no dependencies | Adjacent `.test` file |
| BIT | Single implementation against interface | Adjacent `.test` file |
| Integration | Multiple components interacting | `tests/` directory |
| E2E | Full system behavior | Separate test project |

**BIT** = Behavioral Interface Test. Tests that an implementation fulfills its interface's behavioral contract.

## When Separation Makes Sense

- **Integration tests** exercising multiple modules → `tests/` directory
- **E2E tests** spinning up the whole system → separate test project
- **Shared fixtures** → `src/test_utils/`, not a parallel tree

Don't separate without reason. Colocation is the default.