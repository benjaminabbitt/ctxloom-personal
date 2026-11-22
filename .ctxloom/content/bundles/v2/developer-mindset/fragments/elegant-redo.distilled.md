---
source_sha256: 0914bafa16a2f8a526667b0f66d8ed54b752d3900c2739c758ef7b343482f4d8
---
# Elegant Redo: Informed Reimplementation

Discard the current implementation and rebuild from scratch, using what the first attempt taught.

## Philosophy
- The first attempt's main output is knowledge (hidden requirements, edge cases, dead ends), not its code.
- The second attempt is the one that solves the problem well.

## Process
1. **Inventory first**, before deleting anything. Record:
   - Hidden requirements found
   - Surprising edge cases
   - Architectural constraints
   - Dependencies and interfaces to preserve
   - What worked and should be kept conceptually
   - What was over-engineered
2. **Find the elegant core:**
   - Simplest abstraction covering all known cases
   - Data structures that fit the problem naturally
   - Where the first attempt fought the language/framework
   - What can be deleted entirely vs. what is essential
3. **Scrap and rebuild:**
   - No copy-paste from the old implementation
   - Fresh code shaped by the lessons learned
   - Structure comes from the problem, not the previous solution
   - Reductive: less code, fewer abstractions, simpler interfaces
4. **Validate:**
   - Handles every edge case found in attempt one
   - Passes existing tests (or improved versions)
   - Demonstrably simpler: fewer lines, fewer abstractions, clearer flow

## When It Applies
- Current implementation works but feels forced or over-complicated
- The real shape of the problem has emerged and the code doesn't match it
- Accumulated patches have obscured the original design intent
- Developer explicitly asks for a fresh take

## Rules
- Judge everything on current merit; no sunk-cost preservation
- Simpler is better, but never at the cost of correctness
- Goal is elegance: the minimum structure that handles the full problem
- Keep tests, since they encode requirements. Rewrite implementation, not specifications.
