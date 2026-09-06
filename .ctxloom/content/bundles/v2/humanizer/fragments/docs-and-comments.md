---
tags:
  - writing
  - style
  - documentation
  - comments
notes: Emoji-in-comments and comment-every-line named by developers as near-certain AI tells (arXiv 2603.27249 interview study).
content_hash: sha256:c84cfb8c7b5619ed5da9a556766bed2f482b9f3b03721acf10382945ad15532d
---
# Comments, Doc Comments, READMEs

## Code comments

- Comments state invariants and why — never what the code visibly does ("// loop over items") and never change history ("// added to fix", "// NEW:").
- When tempted to narrate code in a comment, improve the code instead.
- No section-banner comments ("// ===== HELPERS ====="), no emoji, no step-numbered narration.
- No doc-comment boilerplate on trivial functions. If the doc comment restates the signature, omit it (where export docs are required, one factual sentence).

## Doc comments / API docs

- Factual, complete sentences. No marketing adjectives: "powerful", "flexible", "easy-to-use", "blazingly fast".
- Say what it does, its constraints, and its failure modes. Skip the sales pitch.
- Neutral, plain prose is the correct human register for reference text. Don't inject opinions or first person here.

## READMEs and docs

- Size documentation to the project. A 100-line tool doesn't get a table of contents, a badge wall, or a "Features" section with emoji headers.
- What it is, how to install, how to use, one honest example. Add sections when content demands them, not because templates have them.
- No "comprehensive documentation" self-labels, no roadmap/acknowledgements boilerplate in small repos.