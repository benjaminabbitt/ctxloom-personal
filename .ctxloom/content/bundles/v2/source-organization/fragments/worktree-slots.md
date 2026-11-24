---
description: "You are about to cut, check out or build a branch of a project on this machine in a worktree, in any language; to pick which worktree to work in; or to hand a worktree to a child agent, or take one back from it. For anyone about to run git worktree add or git switch for a unit of work, however the moment is worded."
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

A worktree's build state is expensive to make and cheap to reuse, in every
language: Rust's `target/`, a C or C++ build directory, .NET's `bin/` and
`obj/`, Gradle's `build/` and `.gradle/`, Maven's `target/`, a Python
`.venv`, a Node `node_modules/`. Made cold, it costs minutes and often tens
of gigabytes; kept warm, a branch switch rebuilds only what the branch
changed. So on this machine, branches of any project with such state are
worked in a small, fixed POOL of long-lived worktrees, the SLOTS, reused
branch after branch, instead of a fresh worktree per branch. (Go's build
cache is per user, not per worktree, so a Go project gains less; use its
slots all the same, for one rule everywhere.)

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
   checkout. Leave the files and the build state warm.
2. Remove your claim file.

Never `git worktree remove` a slot, never `prune`, and never delete its
build state wholesale (a `target/`, `node_modules/`, `.venv`, `build/`).
The warmth is the point. A project that grows its caches without bound
needs a sweep of its own (ctxloom's landing sweep is one); if a slot's
state is outgrowing the disk, say so to your owner rather than deleting
it.

## Delegating

A child agent is given a slot by its owner, named in its brief. The child
writes its own claim, so the claim follows the session that does the work.
When the owner closes the child, the owner checks the slot is clean before
it treats the slot as free.
