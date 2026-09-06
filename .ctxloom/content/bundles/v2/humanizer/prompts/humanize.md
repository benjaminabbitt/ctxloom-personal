---
description: Audit text for AI-writing tells and rewrite it
tags:
  - writing
  - style
  - editing
notes: 'Audit-then-rewrite: matching banned patterns in existing text is a search task and more reliable than suppressing them during generation. Two-pass cap per community skill convergence (stop-slop, avoid-ai-writing).'
content_hash: sha256:a516a5c89c467c29ed01735c8a168ba121f2eaf11b321049fa7952474a85242e
no_distill: true
---
Audit the given text (or the most recent prose you produced, if none is given) for AI-writing tells, then rewrite it. Checking existing text for banned patterns is more reliable than suppressing them during generation — use this pass on any prose longer than a paragraph that will be read by people.

Pass 1 — flag, don't fix yet:
- Banned vocabulary and phrase templates (humanizer#fragments/banned-phrases)
- Structural tells: rule-of-three triads, "not just X, but Y", trailing participial analysis (", highlighting..."), staccato triplets, hedging stacks, false ranges, vague attribution, certainty inflation, uniform sentence rhythm, em-dash density over one per paragraph
- Formatting tells: bold-term-colon bullets, headers in short text, decorative bold, emoji, "Summary" sections, essay scaffolding
- Tone tells: self-praise ("comprehensive", "robust"), sycophancy, service-desk closers, restated-question intros

Pass 2 — rewrite:
- Restructure each flagged sentence to say the point plainly. Never synonym-swap a banned word; if the sentence conveys nothing, delete it.
- Preserve every fact. Never add invented specifics, sources, or anecdotes to sound concrete.
- Keep the register neutral-professional. Do not inject casualness, opinions, or personality that wasn't there.

Pass 3 — one corrective re-audit of the rewrite. Stop after this pass; if flags remain, list them instead of rewriting a third time.

Report: the rewritten text, then a short list of what was changed and any remaining flags.

Text:
{{text}}