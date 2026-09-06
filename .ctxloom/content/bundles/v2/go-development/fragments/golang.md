---
tags:
  - golang
  - language
content_hash: sha256:5c443acaab4aa5aebb72be1bfaa89a8f24529422967bab5e75eaad97e624daae
---
# Golang Dev

## Env/Tools
- Go version in go.mod
- Testing: stdlib `testing`
- Acceptance: Gherkin (godog)
- Lint: golangci-lint, gofmt/goimports
- Logging: zap

## Test Structure
- Unit: `*_test.go` (co-located)
- Integration: `tests/integration/*_test.go` or build tags
- Acceptance: `tests/acceptance/features/*.feature`

## Testing
- Testify suites for shared setup; skip for single tests
- Mocking: gomock, generate via just target

## Logging
```go
// logmsg/messages.go
const UserCreated = "user_created"
logger.Info(logmsg.UserCreated, zap.String("username", username))
```

## Error Constants
```go
// errmsg/messages.go
const DivideByZero = "cannot divide by zero"
return 0, errors.New(errmsg.DivideByZero)
```

## IoC
```go
func NewUserService(repo UserRepository, logger *zap.Logger) *UserService {
    return &UserService{repo: repo, logger: logger}
}
func NewUserServiceDefault(db *Database) *UserService {  // nolint:unused
    logger, _ := zap.NewProduction()
    return NewUserService(NewSQLUserRepository(db), logger)
}
```