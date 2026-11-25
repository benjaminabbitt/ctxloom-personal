---
tags:
  - default
  - versioning
  - workflow
notes: |-
  Exists because an assistant's default is to protect a format or an interface: version it, migrate it, keep the old shape working, and narrate what changed. In a 0.x.x version nobody depends on the old shape, so each of those habits is cost with no reader, and git already records what changed and why.
---
# Pre-release (0.x.x)

This applies while the software's own version is 0.x.x. That version is a different number from the version of a persisted format, a monotonically increasing integer such as `schema_version`, and is only loosely related to it. In pre-release, a format may carry its format version, but do not use it: no bump for a change of format, no migration, no compatibility shim, and no support for an older shape. This takes precedence over any guidance that says to bump the format version or add a migration step when a persisted shape changes.

Make breaking changes in pre-release without arguing about them. Do not weigh compatibility, offer alternatives that preserve the old shape, or ask whether to break. Change it.

Do not trace provenance or history in code, comments, or docs: no "formerly", "was", "replaces", "removed X", "ported from". Describe what is true now. Git records what changed.

Exception: taskloom tasks. They are state tracking, so a change that affects task data (the shape of a task, its statuses, its tags, stored task files) is put to the human as a question before it is made.
