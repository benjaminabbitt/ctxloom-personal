---
tags:
  - review
  - documentation
content_hash: sha256:6a9e10d15ac7622ef433b0c69cfc99d88ca432bb69b7799714a6744bb8c98c9a
---
# Status Document Pattern

Maintain a gitignored status document to track progress through a multi-session code review.

## Structure

```markdown
# Code Review: [Project/Feature Name]

## Approach
[Brief description of what's being reviewed and why]

## Flow Map
[ASCII diagram showing the flow being traced]

## Files to Review
| File | Status | Notes |
|------|--------|-------|
| path/to/file.rs | [x] | Brief notes |

## Session Log
### Session N: [Date/Topic]
**Reviewed:**
- [x] file1.rs - key observation

**Next:**
- [ ] file3.rs - what to look at

## Questions/Notes
[Observations, questions, design decisions]

## Summary
[Key patterns, learnings, decisions made]
```