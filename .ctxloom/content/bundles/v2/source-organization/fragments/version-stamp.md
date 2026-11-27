---
description: "You are about to stamp a binary or release with a version, show a build's version, compare two versions, or touch the build script, VERSION file or tag that decide them. Also when a version string carries a hash or a timestamp and you must decide what to do with it, or when a tool reports 'dirty'. For anyone building, releasing, or version-checking a ctxloom-family program."
tags:
  - source-organization
  - versioning
  - release
  - build
  - version-control
notes: |-
  Owner's ruling, 2026-11-27: one version-stamp pattern across the ctxloom
  family (ctxloom and taskloom first). Before it each program either said
  only its Cargo version, which names no commit, or kept a hash on a tagged
  release and ended a dirty build with a "-dirty" word beside its time. The
  stamp now says, in its own shape, exactly three things: a release is the
  bare version, a clean build adds the commit, a dirty build adds the time
  it was made. Nothing else is in it, so nothing else needs reading out of
  it.
---
# Version Stamp

A program built from a repository names itself with one stamp, in one of three forms. `<version>` is `MAJOR.MINOR.PATCH`, with an optional `-pre` (`0.2.0-rc.1`); `<hash>` is the short commit hash, seven lowercase hex digits.

| Tree | Stamp | Example |
|---|---|---|
| A **tagged release**: HEAD is exactly the tag `v<version>`, no tracked change | `v<version>` | `v0.1.0` |
| An **untagged, clean** tree | `v<version>-<hash>` | `v0.1.0-abc1234` |
| A **dirty** tree: a *tracked* file changed | `v<version>-<hash>-<YYYYMMDDTHHMMSS>` | `v0.1.0-abc1234-20261127T101010` |

- **The time is the build's, in UTC.** Each dirty build is its own stamp, so two builds before a commit can be told apart. There is no `-dirty` suffix: the datetime itself says the tree was dirty. An untracked file is not a change (set `dirty.ignoreUntracked: true`), or a program that writes files into its own checkout is dirty on every build.
- **A clean build's stamp holds still.** The same commit builds to the same stamp, so clean builds cache. A dirty tree at the release tag is still dirty: it carries the hash and the time.
- **The VERSION file is the source.** It holds the version with no `v` (`0.1.0`), and the release tag is `v` plus it. The tag is cut by a person, never an agent; the stamp only reads it.

## versionator produces it

[versionator](https://github.com/benjaminabbitt/versionator) (v0.3.0 or newer, `go install github.com/benjaminabbitt/versionator@v0.3.0`) reads VERSION and git and gives the pieces: the version, the short hash, the build's UTC time, and whether the tree is dirty. `.versionator.yaml` sets the `v` prefix and `dirty.ignoreUntracked`. It names no tag (only how many commits HEAD is past the last one), so the build script also asks git whether `v<version>` points at HEAD (`git tag --points-at HEAD`); the release form is chosen when it does and the tree is clean. versionator must be on PATH wherever the program is built, CI included, and a build without it fails and says how to install it, rather than shipping an unstamped binary.

## Applied in build.rs

The build script is the only place the stamp is made. It runs versionator, composes the stamp in pure functions (the three forms, the shape check, the tag test) that the program's tests hold, and hands the text to the compiler (`cargo::rustc-env=<PROGRAM>_VERSION_STAMP=...`). It re-runs when a commit, a checkout, a tag or an edit to a tracked file could change the stamp, and at every build of a dirty tree (so the time is that build's). A mutation tool's copy of the tree keeps `.git`, or the copy cannot stamp.

## The binary refuses a malformed stamp

A program checks its own stamp against the shape before it runs anything, and a stamp that is missing or malformed ends it with a coded error naming the stamp and the fix (`build it through the task runner`). A build that cannot say which commit it is cannot be told apart from any other, and a bug report against it is unanswerable. The build script refuses first; the check at start is the second guard, for a binary the stamp never reached. `--version` and any `version` command print the stamp whole.

## Comparisons ignore the hash and the datetime

Order and equality of versions read `MAJOR.MINOR.PATCH[-pre]` and nothing after it, by semver precedence (a release above its own pre-releases, numbers by value). The hash orders nothing, and the datetime orders nothing: `v0.1.0`, `v0.1.0-abc1234` and `v0.1.0-abc1234-20261127T101010` are one version, none newer. This is what a client-and-daemon skew check, an "is the installed binary older than the tool" gate, and a held-message "is the sender up to date" rule all use, so a daemon built from a release and a client built from the next commit are not seen as mismatched.

To read the version out of a stamp, take off an optional trailing `-<YYYYMMDDTHHMMSS>`, then, by its shape (seven lowercase hex digits), an optional trailing `-<hash>`. A tagged pre-release whose last identifier happens to be exactly seven hex digits would read as a hash; avoid naming one so.

## Don't

- Don't parse a stamp by splitting on dashes and counting fields: a pre-release has dashes too.
- Don't compare stamps as strings, or let the hash or the time break a tie.
- Don't add a `-dirty` word, a branch name, or a build number: the three forms are the standard.
- Don't hand-edit the stamp, set it from an environment variable, or fall back to the Cargo version when versionator is missing.
