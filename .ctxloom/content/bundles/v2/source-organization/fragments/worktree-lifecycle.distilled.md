---
distilled_by: claude-haiku-4-5-20251001
---
# Worktree Lifecycle

**One worktree = one branch = one merge.** Agents in one work unit take turns in the same worktree or return read-only patches.

Every agent plan gets a worktree.

## Commit always

**Loss prevented only by committing.**

- Commit at every checkpoint (WIP, red)
- `--no-verify` OK on work-unit branches
- Merge is quality gate; clean history on entry
- Dirty tree: `remove` refuses without `--force`
- Uncommitted work in deleted worktrees is lost forever

## Done = merged + removed + deleted

Done ≠ "merged"; done = **merged, worktree removed, branch deleted.**

Worktrees ARE the ledger of open work. Stop at merge → accumulation.

Verify integration against actual branch (often not `main`). Use `git cherry <integration-branch> <branch>` (−-prefix = already upstream).

## Never force, never adopt

- **Never `git worktree remove --force` or `git branch -D`** — destroys uncommitted work
- **Never remove worktrees you didn't create**
- **Reaping = TRIAGE:** merged & clean → remove; dirty/unmerged → report human
- **`.git` is SHARED** — `branch -D`, `remove`, `gc`, `reflog expire` hit whole repo

## Worktrees from harnesses

Typical issues:

- **Stale base:** branches from ancestor/`origin/HEAD` (missing unpushed commits). Pin base SHA; verify `git log -1`.
- **Placement:** `/tmp` or scratchpad (wiped without warning). Keep only as commits.
- **Auto-clean:** directory vanishes; branch survives. Must commit.
- **`git worktree list --porcelain`** = ground truth.

## Recovering deleted worktrees

Order: `git worktree list` → branch ref → `git reflog` → `git fsck --lost-found`.

Only uncommitted work is lost.