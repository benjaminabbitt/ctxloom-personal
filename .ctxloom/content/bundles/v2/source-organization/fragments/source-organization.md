---
tags:
  - source-organization
  - git
  - worktree
  - layout
notes: |-
  The convention answers two concrete pains rather than a taste for
  tidiness. First: most tooling — shell prompts, editor and tmux titles,
  container names, error messages — shows only a directory's leaf, so a
  checkout whose leaf is "main" is anonymous, and with several repos open
  it is anonymous several times over; the retired <repo>/main layout that
  the installation text migrates away from produced exactly this. Second: a
  worktree inside or beside the repository is a second full copy of the
  codebase sitting inside whatever builds, indexers, recursive greps, and
  container mounts consider their working set — every one of those tools
  was observed picking the copy up. The single shared worktree root is
  what makes one ls of it the machine-wide ledger of open work, which is
  the property the worktree-lifecycle fragment's "done means gone" rule
  depends on.
installation: |-
  This bundle is a workspace layout convention. There are no harness rules to add — the convention is enforced by where you clone repos and where you place worktrees.

  A repo checked out at `<repo>/main` (the retired layout, where worktrees were siblings of `main` under a `<repo>/` parent) should be migrated. Moving worktrees out of the repo parent is what frees the primary checkout to take the project's name back:

  1. Relocate every extra worktree out to the shared root, so the `<repo>/` parent holds nothing but `main`:
     ```
     git -C <repo>/main worktree list
     git -C <repo>/main worktree move <repo>/<branch> ~/workspace/worktrees/<project>--<branch-slug>
     ```
  2. Flatten the primary checkout so its leaf names the project:
     ```
     mv <repo>/main <repo>.tmp
     rmdir <repo>
     mv <repo>.tmp <repo>
     ```
  3. Update any tooling, IDE projects, container mounts, or shell aliases that referenced the old paths.

  Do not migrate repos used by other tools without checking them first; some build systems hard-code paths. Never relocate a worktree with uncommitted work in it — commit first (see the worktree-lifecycle fragment).
content_hash: sha256:051fb65e3c6e3034ff08b6fa475d46f87712b2755c3964a1b6b2a0027ef401a9
---
# Repository and Worktree Layout

The primary checkout is a plain clone whose leaf directory is the **project name**:

```
~/workspace/<project>
```

Related repos may be grouped a level deeper (`~/workspace/<family>/<project>`); the leaf is the project either way.

Most tooling shows you only the leaf — editor titles, shell prompts, tmux windows, container names, error messages. A leaf called `main` tells you nothing about where you are, and with several repos open it tells you nothing several times.

Worktrees live **outside every repository**, under a single root shared by all projects:

```
~/workspace/worktrees/<project>--<branch-slug>    # e.g. ctxloom--docs-fix-drift
```

Flat, not nested. The leaf carries both the project and the branch, so it stays unambiguous in the tooling that shows only a leaf, `ls ~/workspace/worktrees` is the whole ledger of open work across every project on the machine, and `~/workspace/worktrees/<project>--*` still globs per project.

Slugify `/` in branch names for the directory only (`feature/auth` → `feature-auth`); the branch name itself is unchanged.

## Why outside the repo

A worktree next to the source is a second copy of the codebase sitting inside whatever the build, the indexer, the container mount, or the packager thinks its working set is. Copy-the-module-dir tooling copies them. Recursive greps report every hit N times. Devcontainer mounts pull them in. Keep the repository directory holding exactly one tree.

## Common Mistakes

- Naming the primary checkout `main` — the leaf must name the project
- Placing a worktree inside the repo, or beside it — worktrees go in the root, always
- Reusing a removed worktree's directory name without running `git worktree prune` first
