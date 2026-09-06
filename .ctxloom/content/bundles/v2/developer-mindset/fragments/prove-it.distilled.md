---
distilled_by: claude-code
---
# Prove It: Behavioural Diff Demonstration

Show concrete behaviour difference between main branch and current branch.

## Process
1. Identify behavioural claims - what should differ?
2. Design demonstrations exercising changed behaviour
3. Show before (main branch behaviour)
4. Show after (current branch behaviour)
5. Present side-by-side diff of inputs, outputs, effects

## Demonstration Methods
- Test output comparison across branches
- CLI invocation: same command, different output
- Code walkthrough: trace input through both paths, show divergence
- API calls: same request, different responses
- Error scenarios: differing failure modes

## Format

Per behavioural change:
```
## [Behaviour description]
### Main branch
Input: ... Output/Behaviour: ...
### This branch
Input: ... Output/Behaviour: ...
### What changed
[Concise diff explanation + why it matters]
```

## Rules
- Cover all intended changes, not just happy path
- Include edge cases and error conditions
- For pure refactors, demonstrate preserved behaviour
- Show evidence, don't just claim
- If local demo impossible, describe what would be tested and how