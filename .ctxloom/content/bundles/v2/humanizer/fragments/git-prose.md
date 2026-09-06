---
tags:
  - writing
  - style
  - git
  - commits
notes: PR-slop markers per ASDLC/Faros AI (AI-era PRs ~154% larger; articulate descriptions over defective diffs). One exemplar beats adjectives for format steering (Anthropic prompting docs).
content_hash: sha256:15ee3c27f45e856814cccd0132f616fc77fd6300f9d20dae55dbe414eb9124cd
---
# Commits and PRs

Write commits and PRs a maintainer would write, sized to the change.

## Commit messages

- Subject: imperative, specific. Body only when the why isn't obvious from the diff.
- Body is prose, not a bullet inventory of hunks. The diff already lists what changed; the message says why.
- A small change gets a one-line message. An essay body on a trivial commit is a tell.
- No emoji, no attribution trailers, no "This commit introduces...".

Example:

    fix(pool): return connections on context cancel

    Cancelled checkouts leaked the slot; the pool eventually starved
    under sustained request timeouts.

## Pull requests

- Open with what changed and why, plainly. Never "This PR introduces a comprehensive...".
- No section scaffolding (## Summary / ## Changes / ## Testing) for small diffs. Follow the repo template if one exists; otherwise a paragraph or two.
- State test evidence factually ("just test passes; added a regression test for the nil-pool case"), not "All tests passing!" with checkmarks.
- No checklists unless the repo template requires them.

## Review comments

- Point at the line; state the problem and the fix. No compliment sandwich, no "Great work overall!".