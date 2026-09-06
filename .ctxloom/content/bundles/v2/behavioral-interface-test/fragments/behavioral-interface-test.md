---
tags:
  - pattern
  - testing
  - interfaces
  - traits
  - bit
content_hash: sha256:b773c12a6ef362439137473a552d5122409c402fdb8b54640207337334a55b14
---
# Behavioral Interface Test (BIT)

A BIT verifies that a concrete implementation satisfies the behavioral contract defined by its interface (trait, protocol, abstract class). BITs ensure implementations are substitutable.

Touching a real database does not make a test an "integration test" — a BIT still tests one module against its interface.

| Test Type | What It Tests | Where It Lives |
|-----------|--------------|----------------|
| Unit | Pure logic, no dependencies | Adjacent `.test` file |
| BIT | Single implementation against its interface | Adjacent `.test` file |
| Integration | Multiple components interacting | `tests/` directory |
| E2E | Full system behavior | Separate test project |

## Colocate BITs

Tests live next to the code they test — the "real database" aspect doesn't change where the test belongs:

```
src/storage/
├── postgres.rs              # PostgresEventStore implementation
├── postgres.bit.rs          # BITs against real Postgres
├── sqlite.rs
└── sqlite.bit.rs
```

## Same Interface, Multiple Implementations

Write one shared BIT suite per interface; run it against every implementation to guarantee substitutability:

```rust
fn event_store_bits(store: impl EventStore) {
    store.append("stream-1", vec![event]).unwrap();
    assert_eq!(store.read("stream-1").unwrap().len(), 1);
    assert!(store.read("unknown").unwrap().is_empty());
}

#[test]
fn postgres_passes_event_store_bits() { event_store_bits(PostgresEventStore::new(/*...*/)); }

#[test]
fn in_memory_passes_event_store_bits() { event_store_bits(InMemoryEventStore::new()); }
```

## Test Speed and Categorization

Container-backed BITs are slower (~2s startup). Gate them behind a feature; they stay colocated, just conditionally executed:

```rust
#[test]
#[cfg_attr(not(feature = "testcontainers"), ignore)]
fn bit_postgres_storage() { /* runs with --features testcontainers */ }
```

Local dev: fast tests continuously. Pre-commit: all tests including BITs. CI: everything.