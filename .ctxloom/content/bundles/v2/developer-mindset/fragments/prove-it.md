---
tags:
  - workflow
  - testing
  - validation
content_hash: sha256:1622d2d201fe61888fc46c71e5e4cb9cdd8381c07b4c3ca1cfe0fcdea2c342d2
---
# Prove It: Behavioural Diff Demonstration

Demonstrate that changes work by showing the concrete difference in behaviour between the main branch and the current branch.

## Process

1. **Identify the behavioural claims** - What is this branch supposed to change? What should be different?
2. **Design demonstrations** - Create concrete scenarios that exercise the changed behaviour
3. **Show the before** - Run the demonstration against the main branch (or describe its behaviour based on the code)
4. **Show the after** - Run the same demonstration against the current branch
5. **Present the diff** - Side-by-side comparison of inputs, outputs, and observable effects

## Demonstration Methods

- **Test output**: Run tests on both branches, compare results
- **CLI invocation**: Execute the same command on both branches, show output differences
- **Code walkthrough**: Trace the same input through both code paths, show where behaviour diverges
- **API calls**: Same request, different responses
- **Error scenarios**: Show how failure modes differ between branches

## Presentation Format

For each behavioural change:

```
## [Description of behaviour]

### Main branch
Input: ...
Output/Behaviour: ...

### This branch
Input: ...
Output/Behaviour: ...

### What changed
[Concise explanation of the difference and why it matters]
```

## Rules

- Cover all intended behavioural changes, not just the happy path
- Include edge cases and error conditions
- If a change is purely structural (refactoring), demonstrate that behaviour is preserved
- Do not claim changes work without evidence - show, don't tell
- If demonstration requires infrastructure not available locally, describe what would be tested and how