---
tags:
  - testing
  - bdd
  - gherkin
  - acceptance
content_hash: sha256:1104515e9ee211e437914bfdb45ac18796d1cd8f8bcdd99ee32f03f1501f3aeb
---
# Gherkin Authoring

Gherkin is business-readable specification, not test code. Describe **what** the system does and **why** it matters — never **how**.

**The litmus test:** "Will this wording change if the implementation changes?" If yes, abstract to behavior.

## Feature Preambles

Open features with context explaining:
- **What** this capability enables
- **Why** it matters to the business
- **What breaks** if it doesn't work

```gherkin
Feature: Player fund reservation

  Players must reserve funds when joining a table. This ensures:
  - Players can cover their buy-in before sitting down
  - Funds are locked and cannot be double-spent across tables

  Without fund reservation, players could join multiple tables with
  the same bankroll, creating settlement disputes.
```