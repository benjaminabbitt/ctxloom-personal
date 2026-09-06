---
tags:
  - github
  - ci-cd
  - just
  - git
content_hash: sha256:cd434ec6b5e78b9edb7791ad6fed9d7f3cb7efc11b7add1f014950bc78ba425e
---
# CI/CD: Use Just Targets

All CI/CD pipelines invoke just targets for project-specific operations. If project-specific information is encoded into a command, wrap it in a just target.

## What Goes in Just Targets

- **Build**: `just build`, `just build-release`
- **Test**: `just test`, `just test-unit`, `just test-integration`
- **Lint**: `just lint`, `just fmt-check`
- **Deploy**: `just deploy-staging`, `just deploy-prod`
- **Package**: `just package`, `just docker-build`
- **Release**: `just release`, `just bump-version`
- **Generate**: `just codegen`, `just proto`

## What Stays in CI/CD Config

- **Git operations**: `git checkout`, `git fetch`, `git push`
- **Tool setup**: `actions/setup-go@v5`, `actions/setup-node@v4`
- **Caching**: `actions/cache@v4`
- **Artifact handling**: `actions/upload-artifact@v4`
- **Environment setup**: setting env vars, secrets injection
- **Exploratory**: `ls`, `pwd`, `cat`, `echo` for debugging