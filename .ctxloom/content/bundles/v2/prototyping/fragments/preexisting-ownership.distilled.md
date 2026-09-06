---
distilled_by: claude-haiku-4-5-20251001
---
# "Pre-existing" Is Not a Disposition

"Pre-existing" = HISTORY, not decision. Own all shipped failures.

## Valid responses
1. **Fix it** — preferred; already root-caused + code already read + fast gates settle it = do it now
2. **Raise it with the human** — sufficient context: failure, reproduction, ruled-out causes. You do not file it yourself; they decide if it becomes a task

NOT: "Noted, pre-existing" or unread-report mentions.

## Verify before claiming
- `git log -S '<symbol>'` — when introduced?
- `git log -- <path>` — current/today's work touch this?

Failures in recent tests ≠ pre-existing. Verify; assumption often inverted.

## Default rule
**Unexplained red: yours until proven otherwise.**

Intermittent failures in untouched packages appear external, wave through unvetted. Omitting verification defaults failures to someone else's backlog. Defects skip triage, reach CI, dismissed again.

Example: Two agents labeled same test "pre-existing/unrelated"—actually introduced hours earlier by their commit (real capture-integrity bug).