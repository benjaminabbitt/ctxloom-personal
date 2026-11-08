---
tags:
  - versioning
  - workflow
notes: |-
  Exists because an assistant's default is to protect a format or an interface: version it, migrate it, keep the old shape working, and narrate what changed. In a 0.x.x version nobody depends on the old shape, so each of those habits is cost with no reader, and git already records what changed and why.
---
# Pre-release (0.x.x)

A 0.x.x version may carry the machinery for versioning, such as a version field on a file, a schema number, or a version in a path, but do not use it: no migrations, no compatibility shims, no support for an older shape, and no version bump for a change of format. This takes precedence over any guidance that says to bump a version or add a migration step when a persisted shape changes.

Make breaking changes in pre-release without arguing about them. Do not weigh compatibility, offer alternatives that preserve the old shape, or ask whether to break. Change it.

Do not trace provenance or history in code, comments, or docs: no "formerly", "was", "replaces", "removed X", "ported from". Describe what is true now. Git records what changed.

Exception: taskloom tasks. They are state tracking, so a change that affects task data (the shape of a task, its statuses, its tags, stored task files) is put to the human as a question before it is made.
