---
description: "You are about to land a branch: merge, squash, rebase or fast-forward it onto another, push the result, or decide how a finished feature or fix reaches its target. Also when choosing how to bring a target's newer commits into a work branch. For anyone whose next command integrates one branch into another, however the moment is worded."
tags:
  - source-organization
  - git
  - merge
  - workflow
  - version-control
notes: |-
  Owner's standard operating procedure, 2026-11-27: feature branches and bug
  fixes are squash-merged by default; long-lived integration branches are
  merged normally. A work branch's history is the record of how it was
  built: WIP, red-then-green, review rounds, prototypes tried and dropped.
  Landing that record on a target makes its log unreadable and leaves
  remnants (a prototype and its revert) that the owner's no-cruft rule
  forbids. An integration branch's history is the opposite: a record of
  what was integrated, which later merges, bisects and the "merged" checks
  depend on, so it is never flattened.
---
# Merge Policy

How a branch lands depends on what KIND of branch it is. Decide the kind first, then the command follows.

## Work branches are squash-merged (the default)

A **feature branch** or a **bug-fix branch** lands as ONE commit on its target:

```sh
git switch <target>                 # in the target's own checkout or worktree
git merge --squash <branch>
git commit                          # through the hooks; never --no-verify
```

- **One commit, one change.** Write its message for the target's log, not the branch's. The subject says what is now true, imperatively. The body says why, what it supersedes, and every task or ruling ID it settles. A bookkeeping pass reads bodies, not the branch's subjects.
- **The squash commit runs the gates.** `git merge --squash` stages the change and commits nothing, so `git commit` runs pre-commit like any commit. Land it through the repository's own land gate and push in the command that saw it pass.
- **Nothing of the branch's history survives on the target, deliberately.** WIP commits, red commits, a prototype and its revert, review fix-ups: none of them land. So there is no need to clean the branch's history before landing. The squash does it.
- **Bringing the target in while you work:** merge the target into the branch normally (`git merge <target>`). It costs nothing, because the squash flattens it away. Do not rebase a branch someone else may hold.
- **Exception, by the human only:** a human may ask for a branch's commits to be kept, for example a sequence meant to bisect apart. Then merge it normally and say so in the report. An agent never chooses that on its own.

## Long-lived integration branches are merged normally

An **integration branch** stays alive while work lands on it, and it lands on its own target later. Examples: `*/integration`, release and pre-release branches, a night's `integration/<date>` queue branch. It is merged with a MERGE COMMIT:

```sh
git merge --no-ff <integration-branch>
```

- **Never squash it, and never rebase it.** Its history is the record of what was integrated and when. The work branches already squashed onto it are its commits, and later merges, bisects and "is it merged" checks rely on that ancestry.
- **A fast-forward is acceptable** only where the target has no commits of its own and the repository's gate allows it. A merge commit is the default, because it keeps the integration visible as one event.
- **Work branches land ON an integration branch by squash,** the same as they land on `main`.

## After a squash: proving the branch landed

A squash leaves the branch unmerged by ancestry. `git branch --merged` will not list it, `git branch -d` refuses it, and `git cherry` shows its commits as missing, because no one of them is the squash. So before the branch is deleted (done = merged + worktree removed + branch deleted; see `worktree-lifecycle`), prove its CONTENT landed:

```sh
base=$(git merge-base <squash-commit>^ <branch>)
[ "$(git diff "$base" <branch> | git patch-id --stable | cut -d' ' -f1)" = \
  "$(git show <squash-commit> | git patch-id --stable | cut -d' ' -f1)" ] && echo landed
```

- Equal patch ids mean the squash commit holds exactly the branch's change.
- If they differ, for example because a conflict was resolved during the squash, compare by hand. If you can't prove it, keep the branch and tell the human.
- Once proven, delete the branch with `git branch -D <branch>`. This is the one place the forced delete is right: the proof stands in for the ancestry check that `-d` cannot make. Name the squash commit in your report.

## Which kind is it?

- **Cut for one unit of work and finished when that work lands:** a work branch. Squash it.
- **Lives on to receive other work and lands later as a whole:** an integration branch. Merge it.
- **Unsure:** ask the human before landing. A squash that should have been a merge loses an integration record, and it cannot be undone once others build on the target.
