---
description: "You are about to cut, check out or build a branch of a large Rust project on this machine in a worktree; to pick which worktree to work in; or to hand a worktree to a child agent, or take one back from it. For anyone about to run git worktree add or git switch for a unit of work, however the moment is worded."
tags:
  - source-organization
  - git
  - worktree
  - workflow
notes: |-
  Owner ruling 2026-11-24: the slot pool is an agent rule for this machine
  only, with no code in any repository (it replaced ctxloom's scripts/slot.sh).
  A claim is tied to a session name, not a pid, because a daemon re-host
  keeps the session and changes every process (the old lease was lost on
  re-host).
---

# Worktree slots (this machine only)

A Rust worktree's cold `target/` costs minutes and tens of gigabytes; a
warm one rebuilds only what a branch changed. So on this machine, branches
of a large Rust project are worked in a small, fixed POOL of long-lived
worktrees, the SLOTS, reused branch after branch, instead of a fresh
worktree per branch.

This is a convention for agents on this machine. No repository holds code
for it, and no project's docs describe it.

## Where the slots are

`~/workspace/worktrees/<project>--slot-<n>`, n = 1 to 3. This is a stated
exception to the `<project>--<branch-slug>` naming rule: a slot holds many
branches in turn, so it is named by its number. Make one (`git worktree add
--detach <path>`) only when every existing slot is taken.

## Taking a slot

A slot is TAKEN by the claim file
`$(git rev-parse --git-common-dir)/slots/slot-<n>`, one line:
`<your session name> <branch> <UTC time>`. Your session name is the last
segment of `$CTXLOOM_SESSION`. A slot with no claim file is free.

1. Prefer the slot whose HEAD is already your branch. Its target is warmest
   for it, and it is the only slot that can hold that branch.
2. Otherwise take a free slot that is CLEAN: `git -C <slot> status
   --porcelain` prints nothing, and its HEAD is detached at a commit some
   ref holds. Skip a free slot holding work. Someone's crash left it; say
   so in your report and leave it alone.
3. Write the claim file BEFORE you switch. Then `git -C <slot> switch
   <branch>` (or `switch -c <branch> <base>`).
4. All three taken: say who holds each, and wait or escalate. Do not make a
   fourth slot, and never take a claimed one.

## A claim is live while its SESSION is

Judge a claim by its session, never by a process: `ctxloom session show
<name>` reads LIVE, or the session is open and only between runs. A daemon
re-host keeps the session and its name, so a claim survives a re-host. A
claim whose session is ENDED and CLOSED, or which `ctxloom session show`
cannot find, is stale. Remove it only once the slot is clean. Otherwise
the slot holds someone's only copy of their work: report it to your owner.

## Handing back

When your branch is merged or handed over, and the slot is clean and its
commits are on a remote or merged:

1. `git -C <slot> switch --detach`. The branch is then free for any other
   checkout. Leave the files and `target/` warm.
2. Remove your claim file.

Never `git worktree remove` a slot, never `prune`, and never delete its
`target/` wholesale. The warmth is the point; the project's landing sweep
keeps the caches bounded.

## Delegating

A child agent is given a slot by its owner, named in its brief. The child
writes its own claim, so the claim follows the session that does the work.
When the owner closes the child, the owner checks the slot is clean before
it treats the slot as free.
