---
description: Tools this bundle's content needs where agents run (applied via `ctxloom tooling`, user-approved)
tags:
  - tooling
---
This bundle's content drives the `ast-grep` CLI, so agent environments
(the agent container image) need it installed:

- ast-grep: Homebrew (`brew install ast-grep`), a pinned release binary
  from https://github.com/ast-grep/ast-grep/releases, or
  `cargo install ast-grep --locked`.
