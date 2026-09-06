---
distilled_by: claude-code
---
# Behavioral Interface Test (BIT)

Verifies a concrete implementation satisfies its interface's behavioral contract — ensures substitutability. Touching a real database does not make it an integration test.

| Type | Tests | Lives |
|------|-------|-------|
| Unit | Pure logic, no dependencies | Adjacent `.test` file |
| BIT | One implementation vs its interface | Adjacent `.test` file |
| Integration | Multiple components interacting | `tests/` directory |
| E2E | Full system | Separate test project |

Colocate BITs with the implementation: `postgres.rs` + `postgres.bit.rs` side by side.

Multiple implementations: one shared BIT suite fn per interface (`fn event_store_bits(store: impl EventStore)`); each implementation gets a `#[test]` that calls it.

Gate container-backed BITs: `#[cfg_attr(not(feature = "testcontainers"), ignore)]`. Local dev: fast tests; pre-commit: all tests including BITs; CI: everything.