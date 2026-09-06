---
tags:
  - code
  - strings
  - errors
content_hash: sha256:5278e4fbf6ebf5b7bfe478c7ab3579c6297d3a1b7e73a49bce9b4ce88ac3cd3b
---
# String Handling

## No String-Based Flow Control

Never use string approximations (`startswith`, `endswith`, `contains`, substring matching) for program flow control unless explicitly instructed. Use typed errors or error codes instead.

```go
// Wrong
if strings.Contains(err.Error(), "connection refused") {
    retry()
}

// Right
if errors.Is(err, ErrConnectionRefused) {
    retry()
}
```

## Error Messages as Constants

All error messages must be defined as constants and reused in test assertions. No magic strings.

```go
// errors.go
var ErrUserNotFound = errors.New("user not found")

// service.go
return ErrUserNotFound

// service_test.go
assert.ErrorIs(t, err, ErrUserNotFound)
```