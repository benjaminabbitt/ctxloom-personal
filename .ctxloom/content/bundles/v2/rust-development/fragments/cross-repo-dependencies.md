---
tags:
  - rust
  - dependencies
  - reproducibility
notes: |-
  Exists because sibling-repo crates referenced by `path` build against
  whatever the neighbouring checkout holds, uncommitted edits included: a
  fresh clone or CI can't build, and nothing records which revision a commit
  was tested with. Found in taskloom, 2026-10-25, depending on annals by
  path.
---
# Cross-repo dependencies: pin by git rev, patch locally

- A crate from another repository is a git dependency pinned by full
  commit (`git = "...", rev = "<sha>"`). Never commit a `path` to another
  repo.
- Bump a pin on purpose, in its own commit, after the other repo is pushed.
- To develop against a local checkout, override the pin with a `[patch]`
  section in `.cargo/config.toml` (or another uncommitted file), and remove
  it before committing.
