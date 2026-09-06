---
tags:
  - writing
  - docs
  - truthfulness
  - verification
notes: 'Every rule here is derived from a real defect found in a multi-agent audit of the ctxloom website (2026-07-12), not from priors about how docs go wrong. The failure modes are ranked by how much damage they did: silent no-ops beat hard errors, because the user has nothing to search for.'
content_hash: sha256:bc50a429f5070b396b7cadd7a5f6c27031562b1bbd217c6c8e302f6fa3efe513
---
# Claims against code

A docs page is a set of falsifiable claims. Every command, flag, config key, path, default, and described behavior is a promise that the code will do a specific thing. You do not get to write one from memory.

## The rule

**Before you assert it, read the code that implements it.** Not the doc that describes it, not the commit message, not the name of the function. The implementation. A symbol name is a hypothesis; the body is evidence.

When you cannot read it, say so in the draft: mark the claim and go find out. An unmarked guess is indistinguishable from a verified fact to every reader who comes after you, including you in a month.

## The failure modes that actually happen

Ranked by damage, worst first. The ordering is not intuitive — the quiet failures are the expensive ones.

**1. The silently-ignored key.** You document a config key that was renamed or retired. The decoder is not strict, so it does not error — it ignores the key and the user gets a working program with no effect and nothing to search for. This is worse than a crash by a wide margin: a crash names itself. Whenever you document a config key, confirm the struct field still exists *and* confirm what happens to an unknown key.

**2. The promise the code discards.** You document a warning, a validation, or a fallback that the code computes and then throws away — a check wired to a no-op sink, a required field nobody enforces. Grep for the call site, not the definition. A function that builds an error message proves nothing; find who receives it.

**3. The feature behind a build tag.** You describe a capability that exists in the source and is compiled out of the binary your users actually install. Check which build the default install path delivers before you put a capability on the front page.

**4. The wrong argument kind.** You pass a bundle name to a flag that takes a fragment name, a remote alias to a parser that only accepts canonical URLs, a local short name to a lookup that only indexes remote keys. These are the most-copied errors because examples propagate: one wrong invocation on the landing page reappears on five other pages. Run the example.

**5. The omitted step.** The flow you document works, and produces nothing, because you left out the step that authorizes it — the review, the trust decision, the hook install. Walk the flow as a stranger with an empty machine, not as the person who already ran the setup.

**6. The stale absolute.** "Automatically", "always", "never", "isolated", "verified", "only". Each one is a claim with a blast radius. Every absolute needs a specific line of code behind it, and most of them, when you go look, turn out to be conditional.

## Security claims

Hold these to a higher bar than anything else on the page, in both directions.

**Never overclaim.** If you write "sandboxed", "can't touch", "verified", or "signed", the code must actually enforce it — fail *closed*, not warn and proceed. Check the escape hatches: what happens when the checksum file is missing, when the key is absent, when the tool isn't installed? A verification that degrades to a warning is not verification, and describing it as automatic is how a user ends up trusting a binary nobody checked.

**Never underclaim either.** Describing a cryptographic guarantee as a weaker one is its own kind of lie — it teaches the reader to distrust a mechanism that would have protected them, and invites someone to "simplify" it away. Describe what is actually enforced.

## Generated pages

Some reference pages are generated from the code (CLI help, schemas, tool registrations). Two consequences:

- **Never hand-edit them.** The next regeneration reverts you, and CI probably fails on the drift.
- **They are authoritative for surface, not for truth.** A generated page faithfully propagates whatever its source says. If the schema has drifted from the struct, the generated page is confidently wrong and no amount of proofreading the page will find it. When a generated page and the code disagree, the bug is upstream — fix the source, not the prose.

## Aspirational tense

Never describe an unshipped feature in the present tense. If it is designed but not built, it does not go on the site. "Will" is not a fix — a roadmap item in a docs page reads as shipped to every reader who is skimming, which is all of them.