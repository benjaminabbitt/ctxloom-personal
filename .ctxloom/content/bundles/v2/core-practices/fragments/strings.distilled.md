---
distilled_by: claude-code
---
# String Handling

Never branch on string approximations of messages (startswith/contains/substring) unless explicitly instructed — use typed errors or error codes (`errors.Is(err, ErrConnectionRefused)`, not `strings.Contains(err.Error(), ...)`). Define all error messages as constants/sentinel errors and reuse them in test assertions — no magic strings.