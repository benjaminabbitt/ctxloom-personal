---
distilled_by: claude-code
---
# CI/CD: Use Just Targets

CI/CD invokes just targets for anything project-specific: build, test, lint, deploy, package, release, codegen — if a command encodes project info, wrap it in a just target. Only generic operations stay inline in workflow files: git operations, tool-setup/cache/artifact actions, env vars and secrets injection, exploratory debugging (ls/pwd/cat/echo).