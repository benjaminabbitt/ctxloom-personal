---
description: Adversarially fact-check a documentation tree against the code that implements it, and report tiered findings with file:line evidence.
tags:
  - docs
  - verification
  - truthfulness
content_hash: sha256:776953fcfd46b2b3c9f0950b12aa8a0bfcdb6121d84e71497c0c8b2e356de0e8
---
Fact-check the documentation at {{TARGET}} against the code that implements it.

Your job is to REFUTE claims, not to confirm them. Assume the docs have drifted and go find where. A page that looks fine has not been checked; it has been read.

## Establish the oracles first

Before checking anything, pin down, in this order of authority:

1. **The implementation.** The source tree, at a named commit. Record the commit — a finding against the wrong base is noise.
2. **Generated reference**, if any (CLI help from the arg parser, schema dumps, tool registrations). These are authoritative for what the *surface* is. Treat a flag that appears in narrative prose but not in generated reference as a red flag to chase into the source. But remember: a generated page only reflects its generator's input, so if that input has drifted, the page is confidently wrong.
3. **A current binary**, if you can get one, for read-only checks (`--help`, list commands). Confirm it is built from the commit you are checking — a stale binary will happily confirm a stale doc.

Never trust a summary of the code, including one given to you in this prompt.

## Split the work

One agent per small group of pages (two or three). Give each the same oracles and the same tiers. Independent agents catch more than one agent making N passes, and they will not talk each other into a shared wrong assumption.

## Tiers

Label every finding:

- **FALSE** — a command, flag, key, path, default, or behavior that contradicts the code.
- **STALE** — true once; renamed, moved, retired, or inverted since.
- **UNSUPPORTED** — a capability asserted with no implementation you can find, or an absolute ("automatically", "always", "isolated", "verified") the code does not guarantee.
- **MISSING** — for two-way diffs (schema keys, env vars, registered tools): the real thing the doc never mentions.

## Where to push hardest

- **Every fenced code block is a claim under test.** A copy-pasteable command that fails is the most damaging falsehood a docs page can carry, and examples propagate — one wrong invocation on a landing page reappears everywhere.
- **Two-way diff anything enumerable.** Config keys, env vars, MCP tools, subcommands: documented-but-absent *and* real-but-undocumented. One direction is half a check.
- **Security and trust claims.** Overclaiming is the worst defect on any site. If the doc implies a check fails closed and the code only warns, that is a top-priority finding. Underclaiming — describing a strong guarantee as a weak one — is also a finding.
- **Silent failures over loud ones.** A key that is ignored rather than rejected, a warning computed and discarded, a flag inert in the mode it is documented in. These cost users the most because there is nothing to search for.

## Output

Per page, a list of findings. Each one carries:

- the tier
- the exact quoted claim and its line number
- why it is wrong, with code evidence as `file:line`
- the corrected statement

A page with no findings must say so explicitly, and list what was checked — otherwise "no findings" is indistinguishable from "did not look."

Close with what you could not verify and why. Separate **doc bugs** (fix the prose) from **code bugs** (fixing the prose would enshrine the defect) — they go to different people.

Report only. Fix nothing.