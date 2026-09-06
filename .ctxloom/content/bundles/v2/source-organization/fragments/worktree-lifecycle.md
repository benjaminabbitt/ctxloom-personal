---
tags:
  - source-organization
  - git
  - worktree
  - workflow
  - version-control
notes: |-
  Every rule here defends against one of the two ways worktrees actually
  fail. Loss: uncommitted bytes in a working tree are the only state that a
  forced removal, a harness auto-clean, or a /tmp wipe can destroy — hence
  commit-at-every-checkpoint as the sole loss defense, the ban on --force
  (the one command in the set that can destroy work), and the recovery
  ladder that works precisely because committed work survives every
  deletion path. Accumulation: a merged-but-not-removed worktree is
  indistinguishable from live work, so nobody deletes anything and the set
  stops being a ledger — hence done = merged + removed + branch-deleted,
  and one-worktree-per-merge, which exists because a fan-out that cuts a
  branch per agent creates merges that never happen. The harness section is
  there because engine-cut worktrees were repeatedly observed arriving on
  stale bases (branching from origin/HEAD misses every unpushed commit) and
  in wipeable locations; planning for those defaults proved cheaper than
  trusting any harness to get them right.
content_hash: sha256:ee117f6e6e805f840960d9865ac50506b2c18bcdb0c67af441e254e056bb8208
---
# Worktree Lifecycle

A worktree is not a scratch directory. It is an **open work unit**, and its existence is a claim that work is outstanding.

## One worktree = one branch = one merge

The unit of isolation is the MERGE, not the agent. A plan execution gets exactly one worktree, whatever the headcount that runs inside it. If a fan-out of eight agents produces eight branches, you have created eight merges, and they will not happen. Agents within one work unit either take turns in that unit's worktree, or run read-only and return a patch or a report that is never merged.

Every agent-executed plan gets a worktree — no exceptions; isolation is the whole point. A human may make a trivial edit directly in the primary checkout.

## Commit, or it never happened

**Loss is not prevented by careful deletion. It is prevented by committing.**

A commit on a named branch survives every deletion path there is: `worktree remove --force`, a harness's auto-clean, a `/tmp` wipe, `git worktree prune`. Uncommitted bytes in a working tree are the only state that can actually be destroyed. Work "lost with the worktree" was lost dirty; work that was committed is still sitting on its branch.

So commit at every checkpoint — including WIP, including red. `--no-verify` is fine on a work-unit branch. The MERGE is the quality gate, not the individual commit; clean the history up on the way in. An agent that ends its session with an uncommitted working tree has not saved its work, it has staged it for deletion.

A dirty worktree is also unreapable: `git worktree remove` refuses one without `--force`, and `--force` is banned (below). An uncommitted tree is therefore both the only losable state and the reason worktrees pile up. One habit fixes both.

## Done means gone

Done is not "merged". Done is **merged, worktree removed, branch deleted**.

Stop at "merged" and you leave behind a directory indistinguishable from live work. Nobody can tell what is safe to delete, so nobody deletes anything, and the worktrees accumulate until the disk or the grep budget complains. The worktree set IS the ledger of open work: if it exists, work is outstanding. Zero worktrees is a clean desk.

A work unit abandoned rather than merged is still not done until its branch is either deleted or explicitly parked with a written reason. "Might come back to it" is how a repo grows sixty stale branches.

**Measure "merged" against the branch that is actually integrating**, which is often not `main`. A long-lived release or pre-release branch quietly becomes the integration point while `main` sits still; `git branch --no-merged main` then reports a mountain of "unmerged" work that is in fact fully landed. And ancestry is not the only way work lands: rebase, squash-merge and cherry-pick all leave a branch unmerged *by ancestry* while its content is upstream. `git cherry <integration-branch> <branch>` is the tool — a `-` prefix means that patch is already there. Before you believe a branch holds unique work, prove it.

## Never force, never adopt

- **Never `git worktree remove --force`, never `git branch -D`** unless the human explicitly asks. Force is the only command here that can destroy uncommitted work.
- **Never remove a worktree you did not create.** Another session, another agent, or the human may be live inside it.
- **Reaping is TRIAGE, not deletion.** Merged and clean → remove and prune. Dirty or unmerged → leave it and TELL THE HUMAN what you found. A worktree you declined to delete but never mentioned is the same as one you forgot.
- **`.git` is SHARED.** `branch -D`, `worktree remove`, `gc`, and `reflog expire` run from inside a worktree hit the WHOLE repository — including the checkout the human is sitting in. Destructive git is repo-wide, never worktree-local.

## Worktrees you did not make

Harnesses cut their own worktrees, and they get it wrong in ways consistent enough to plan for:

- **Stale base.** The worktree is routinely cut at a stale ancestor — sometimes one predating whole subsystems. Usually this is a *default*, not a bug: Claude Code's `worktree.baseRef` defaults to `"fresh"`, which branches from `origin/HEAD` rather than your local `HEAD`, so every unpushed commit is missing. Set it to `"head"`. Whatever the engine, pin the base SHA in the brief, and `git log -1` on arrival to confirm what you actually got before writing a line.
- **Placement.** They land in `/tmp` or a harness scratchpad, outside the configured root, invisible to any sweep and wiped without warning. Anything you want to keep leaves as a commit or a published artifact — never as a file in that directory.
- **Auto-clean.** "Removed if unchanged" means the directory disappears while the branch survives. The work is recoverable, but only if it was committed.
- **They are not on your ledger.** `git worktree list --porcelain` is ground truth — not the filesystem, and not what the harness told you.

Getting artifacts *out* of an isolated worktree is a separate hazard; see the `worktree-isolation` fragment.

## Recovering apparently-lost work

A deleted worktree directory does not mean deleted work. In order: `git worktree list`, the branch ref, `git reflog`, then `git fsck --lost-found` for detached commits. Only work that was never committed is actually gone.
