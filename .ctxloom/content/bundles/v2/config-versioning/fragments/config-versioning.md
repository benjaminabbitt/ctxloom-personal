---
tags:
  - config
  - persistence
premise: >-
  Adding, changing, or loading a persisted file format: a config file, a
  content file, or any YAML/JSON document a program writes and later reads
  back from disk, including adding or renaming a key in one.
---
# Persisted formats carry their own version

Every file a program writes and later reads back declares the version of its
FORMAT under one key, `schema_version`, as a flat integer that only ever
increases.

## The format version is its own number

It is not the binary's release version and not any version the file's author
assigns to its content (a package's semver, a document revision). Those change
for reasons that say nothing about whether the shape changed, and a reader
keyed to them either refuses files it could read or reads files it cannot.

It is an integer, not semver, because the reader asks exactly one question —
"can I read this, and which migrations bring it current?" — and that needs
ordering, nothing else. Minor/patch levels promise that an older reader copes
with a newer file; a strict decoder breaks that promise on the first unknown
key, so the promise is false where it matters.

## Reading

Decide from the declared version BEFORE decoding into the typed structure:

- **older** — run the registered migrations in order, IN MEMORY, and decode
  the result. The file on disk is untouched.
- **current** — decode as is.
- **newer** — refuse, naming both numbers ("written for format N, this build
  reads up to M; upgrade the tool"). Never guess at a future format.
- **present but not an integer** — refuse as corrupt. Treating it as old runs
  every migration over a broken file and stamps it current: a parse error
  replaced by a clean load of rewritten bytes.
- **missing** — the oldest generation: every migration applies. A format with
  no older generation has nothing to run, so it decodes as current.

The check runs before any strict decode, so a newer file gets the version
message rather than an unknown-field error. A rename of the version key itself
runs before the check, or every file still using the old spelling reads as
undeclared.

## Writing

- Every writer stamps the current version. A file the tool creates is never
  unversioned.
- Reading never writes. A loader that rewrites the file it loads produces
  surprise diffs in checked-in files and races itself when several processes
  load at once.
- Persisting a migration is an explicit act: a flag on the command that owns
  the file, which keeps a backup and can print instead of write.

## Signed content

Verify the signature over the bytes exactly as received, then migrate in
memory. A migration is never re-signed implicitly; writing migrated signed
content back means re-signing it, and that is the signer's act.

## One implementation

The version read, the migrate-in-memory, the newer-refusal and the write-back
helper live in one shared package that every file kind uses. Per-kind code
supplies only its current version and its ordered migrations. The machinery
exists and is tested even when a kind has zero migrations — the steady state,
not a special case: a current file passes through byte-identically, an older
one is migrated and stamped, a newer one is refused, a malformed one is
returned untouched for the decoder to report.
