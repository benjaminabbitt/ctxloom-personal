---
description: Tools the Go development content needs where agents run (applied via `ctxloom tooling`, user-approved)
tags:
  - tooling
  - golang
---
CLIs this bundle's practices assume, beyond the Go toolchain
itself (testify/gomock arrive as go.mod dependencies — only the
commands below need installing, pinned via `go install
<pkg>@<version>` or release binaries):

- golangci-lint: the lint gate (`just lint`).
- goimports: formatting + import management
  (golang.org/x/tools/cmd/goimports).
- godog: the Gherkin acceptance runner
  (github.com/cucumber/godog/cmd/godog).
- mockgen: gomock generation (go.uber.org/mock/mockgen).
