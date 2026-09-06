---
distilled_by: claude-code
---
# Commits and PRs

Maintainer voice, sized to the change.

## Commits
- Imperative, specific subject; body only when the why isn't obvious from the diff
- Body = prose why, not a bullet inventory of hunks
- Small change = one line; essay body on a trivial commit is a tell
- No emoji, no attribution trailers, no "This commit introduces..."

Example:

    fix(pool): return connections on context cancel

    Cancelled checkouts leaked the slot; the pool eventually starved
    under sustained request timeouts.

## PRs
- Open with what changed and why. Never "This PR introduces a comprehensive..."
- No ## Summary/Changes/Testing scaffolding for small diffs; repo template, else 1–2 paragraphs
- Test evidence factual ("just test passes; added regression for nil-pool"), no checkmark theater
- No checklists unless the template requires them

## Reviews
- Line + problem + fix. No compliment sandwich, no "Great work overall!"