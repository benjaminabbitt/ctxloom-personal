---
source_sha256: d025e6d1dc90be6b6a9bdf9439c441b1bd0cca5a1430ee29a30268f474e08b73
---
# String Handling

## No String-Based Flow Control
- Don't branch on strings (`startswith`, `endswith`, `contains`, substring match) unless explicitly told to. Use typed errors or error codes.
  - Wrong: `strings.Contains(err.Error(), "connection refused")`
  - Right: `errors.Is(err, ErrConnectionRefused)`

## Error Messages as Constants
- Define every error message as a constant; reuse it in test assertions. No magic strings.
  - `errors.go`: `var ErrUserNotFound = errors.New("user not found")`
  - `service.go`: `return ErrUserNotFound`
  - `service_test.go`: `assert.ErrorIs(t, err, ErrUserNotFound)`
