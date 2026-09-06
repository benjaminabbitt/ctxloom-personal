---
distilled_by: claude-3-opus
---
# Golang Dev

## Tools
- Acceptance: godog (Gherkin)
- Lint: golangci-lint, gofmt/goimports
- Logging: zap

## Test Layout
- Unit: `*_test.go` (co-located)
- Integration: `tests/integration/` or build tags
- Acceptance: `tests/acceptance/features/*.feature`
- Testify suites for shared setup; gomock via just target

## Constants
```go
// logmsg/messages.go
const UserCreated = "user_created"
logger.Info(logmsg.UserCreated, zap.String("username", username))

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
    return NewUserService(NewSQLUserRepository(db), zap.NewProduction())
}
```