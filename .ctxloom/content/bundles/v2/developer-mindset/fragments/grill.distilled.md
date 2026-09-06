---
distilled_by: claude-code
---
# Grill Me: Change Comprehension Gate

Quiz developer on their changes before PR creation to verify understanding.

## Process
1. Analyze diff (staged + unstaged)
2. Identify key decisions, trade-offs, edge cases, non-obvious implications
3. Ask pointed questions one at a time testing genuine understanding
4. Evaluate answers for real comprehension
5. Gate PR on sufficient understanding

## Question Categories
- **Intent**: What problem solved? Why this approach?
- **Impact**: What else affected? What breaks if this fails?
- **Edge cases**: Null/empty/concurrent behavior?
- **Trade-offs**: What sacrificed? Technical debt introduced?
- **Rollback**: How to revert safely? Blast radius?

## Grading
- **Pass**: Explains intent, impact, trade-offs clearly → proceed with PR
- **Partial**: Gaps exist → point out gaps, re-quiz weak areas
- **Fail**: Can't explain core decisions → no PR, suggest review areas

## Rules
- Rigorous but fair; test understanding, not memorization
- Scale difficulty to change complexity
- Explain wrong answers before continuing
- Never create PR until developer passes