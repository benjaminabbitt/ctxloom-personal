---
distilled_by: claude-code
---
# Elegant Redo: Informed Reimplementation

Discard current impl and rebuild using lessons from first attempt.

## Philosophy
First impl teaches the problem. Second solves it well. Knowledge from edge cases, hidden requirements, and dead ends is the valuable output—not the code.

## Process
1. **Inventory knowledge** - Before deleting, document:
   - Hidden requirements, surprising edge cases
   - Architectural constraints revealed
   - Dependencies/interfaces to preserve
   - What worked vs what was over-engineered

2. **Identify elegant core** - With full problem knowledge:
   - Simplest abstraction covering all cases?
   - Natural data structures?
   - Where did first attempt fight the language/framework?
   - What's deletable vs essential?

3. **Scrap and rebuild** - Start clean:
   - No copy-paste from old impl
   - Let structure emerge from problem
   - Less code, fewer abstractions, simpler interfaces

4. **Validate** - New solution must:
   - Handle all discovered edge cases
   - Pass existing/improved tests
   - Be demonstrably simpler

## When to Apply
- Impl works but feels forced/overcomplicated
- Real problem shape doesn't match code
- Accumulated patches obscure design intent
- Developer explicitly requests fresh take

## Rules
- No sunk cost preservation—judge on current merit
- Simpler is better, but not at correctness cost
- Goal: minimum structure handling full problem naturally
- Keep tests (requirements); rewrite implementation