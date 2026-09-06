---
tags:
  - writing
  - style
  - vocabulary
notes: 'Tier-1 intersection of Kobak et al. (Science Advances 2025, PubMed excess vocabulary), Liang et al. (ICML 2024), Juzek & Ward (COLING 2025), Wikipedia:Signs of AI writing, and four practitioner lists. Kept to ~45 items: instruction-following degrades on long ban lists (IFScale, arXiv:2507.11538). Word lists rot roughly per model generation; re-check against WP:AISIGNS.'
content_hash: sha256:c25d86efb35732984a37f856ebbcd20eaa4eb3820787dbe7db7a8abfe2601c93
---
# Banned Phrases

Words and templates statistically diagnostic of LLM output (Kobak et al., Science Advances 2025; Liang et al., ICML 2024; Wikipedia:Signs of AI writing). The fix is deletion or a plainer sentence — never a synonym swap ("delve" → "dig into" keeps the tell).

## Hard bans

Verbs: delve, underscore, showcase, leverage, harness, foster, elevate, empower, streamline, unlock, unleash, embark, bolster, facilitate, revolutionize, navigate (metaphorical).

Adjectives: pivotal, crucial (as filler), robust (as filler), seamless, comprehensive, meticulous, intricate, multifaceted, transformative, groundbreaking, cutting-edge, ever-evolving, game-changing, invaluable, holistic, vibrant, nuanced (as filler).

Nouns: tapestry, landscape (metaphorical), realm, testament, synergy, journey (metaphorical), beacon, cornerstone, paradigm, myriad, plethora, treasure trove, insights (unqualified).

## Template bans

- "plays a crucial/vital/key role in" → say what it does
- "stands as / serves as / is a testament to" → "is"
- "it's important to note that / it's worth noting that" → just state it
- "in today's fast-paced world / digital age / ever-evolving landscape"
- "not only X but also Y"; "it's not just X — it's Y" → state Y
- "harness the power of"; "unlock the potential of"
- "navigating the complexities of"
- "in conclusion / in summary / overall" as closers
- "furthermore / moreover / additionally" as paragraph glue — if the point follows, just make it

## Escape hatch

A banned word is fine when it's the precise technical term ("robust statistics", "fitness landscape") or inside a quote. What's banned is the default register.