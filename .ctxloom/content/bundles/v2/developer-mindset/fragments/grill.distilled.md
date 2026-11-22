---
source_sha256: ce244a84d6e3a4fc76d68800fa04f1374832ddbaeb3119f8adf2379bff544499
---
# Grill Me: Change Comprehension Gate

Before creating a PR, quiz the developer on their changes to verify understanding.

## Process

1. **Analyze diff**: review all staged and unstaged changes on current branch
2. **Identify key decisions**: architecture, trade-offs, edge cases, non-obvious implications
3. **Formulate questions**: pointed, testing real understanding, not recall
4. **Quiz**: ask one at a time, wait for responses
5. **Evaluate**: does developer understand what changed and why
6. **Gate PR**: create only after sufficient understanding shown

## Question Categories

- **Intent**: problem solved; why this approach over alternatives
- **Impact**: affected system parts; what breaks if it fails
- **Edge cases**: null/empty/concurrent; behavior under condition Y
- **Trade-offs**: what was sacrificed; technical debt introduced
- **Rollback**: safe revert; blast radius

## Grading

- **Pass**: explains intent, impact, trade-offs clearly → proceed with PR
- **Partial**: gaps → point them out, re-quiz weak areas
- **Fail**: can't explain core decisions → no PR; suggest areas to review

## Rules

- Rigorous but fair; test understanding, not memorization
- Difficulty matches change complexity
- Wrong answer: explain why before moving on
- No PR until pass
