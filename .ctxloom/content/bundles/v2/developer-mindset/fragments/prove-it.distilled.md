---
source_sha256: ae7b37f4062772509d52f30192147d3cc0f4cb2461b5aaf5b360d44b6a3f45d4
---
# Prove It: Behavioural Diff Demo

Show concrete behaviour difference between main and current branch.

## Process
1. **Identify behavioural claims**: what should differ?
2. **Design demos**: concrete scenarios exercising changed behaviour
3. **Before**: run demo on main (or describe behaviour from code)
4. **After**: run same demo on current branch
5. **Diff**: side-by-side inputs, outputs, observable effects

## Methods
- **Tests**: run on both branches, compare
- **CLI**: same command both branches, compare output
- **Code walkthrough**: trace same input through both paths, show divergence
- **API**: same request, compare responses
- **Errors**: compare failure modes

## Format
Per behavioural change:

```
## [Behaviour description]

### Main branch
Input: ...
Output/Behaviour: ...

### This branch
Input: ...
Output/Behaviour: ...

### What changed
[Concise difference and why it matters]
```

## Rules
- Cover all intended changes, not just happy path
- Include edge cases and error conditions
- Purely structural (refactor): demonstrate behaviour preserved
- No claims without evidence: show, don't tell
- If infrastructure unavailable locally: describe what would be tested and how
