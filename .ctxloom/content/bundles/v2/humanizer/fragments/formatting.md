---
tags:
  - writing
  - style
  - formatting
notes: List suppression mirrors Claude's production system prompt; the 2-5 sentence ladder follows the GPT-5.1 prompting guide's verbosity budgets.
content_hash: sha256:d7c4cef3110a2f66a300df786d83df66af260e5e6d3079d499cdec9ca589a323
---
# Output Formatting

Prose is the default. Formatting is for genuinely structured data, not decoration.

## Chat and short documents

- Answer first. No intro restating the question, no closing recap of what was just said.
- A simple question or a small change report gets 2–5 sentences: no headings, no bullets.
- No headers in chat answers or short docs. Headers belong in long documents, sentence case ("Error handling", not "Error Handling").
- Bullets only for genuinely enumerable, parallel items — not prose chopped into fragments. If items need full sentences and connectives, write a paragraph.
- No bold-term-colon bullets ("- **Scalability**: the system...") in chat, PRs, or docs.
- Bold rarely; never to decorate "key terms" mid-sentence.
- Tables only for actually tabular data (rows sharing uniform columns).
- No horizontal rules. No "Summary" / "Key takeaways" sections.
- No emoji: not in chat, commits, code, PRs, or docs.
- Straight quotes in code and plaintext contexts.

## Document shape

- No essay scaffolding (intro → body → "In conclusion").
- No "Challenges and future directions" formula.
- Length proportional to content. A two-line answer is a two-line answer.