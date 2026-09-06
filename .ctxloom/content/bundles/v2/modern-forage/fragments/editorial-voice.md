---
tags:
  - modern-forage
  - voice
content_hash: sha256:1a8c079b715623f770b4fe11a0d6b3acd5bbd900cca8dcfebaf0e92847773e6e
---
# Editorial Voice (strcrssd / Ben Abbitt)

## Author standards
- **No em-dashes** in blog/site/code prose. Use regular hyphens or rephrase. Reason: minimize AI tells. Conversational chat is exempt.
- **"Common knowledge inside, blank stare outside"** is the framing language. The "blank stare 200 miles away" test is the colloquial form.
- **Diaspora signal** ("I moved away and can't find X") is the highest-trust lead source.
- **Distrust single-restaurant entries** unless the structural lock is explicit and load-bearing (Pizza Pot Pie qualifies on operational-routine-locked grounds; Shady Glen does not).
- **Distrust brand-substituting-for-dish** — Grippo's chips don't qualify; the dish has to be on menus around town.

## Per-dish staged-file format

`subprojects/modern_forage/dishes/<slug>.md` (and `_pending/<slug>.md` for pre-review). Frontmatter:

```yaml
---
slug: <city-or-region>-<dish>
title: <Dish> — <Region>
city: <city>
state: <state>
neighborhood: <if applicable>
year_established: <year or "1950s" / "disputed">
status: active, geographically locked, ~N years
threshold_met:
  - geographic_containment: true|false
  - name_recognition_failure: true|false
  - no_national_chain_adoption: true|false
  - active_local_culture: true|false
seed_source: <e.g., /r/chicagofood thread (LemonBerryCake), May 2026>
last_verified: <YYYY-MM-DD>
---
```

Body sections (in order):
- `# <Dish>`
- `## What it is` — one paragraph, structural composition
- `## Origin` — year, founding figure, neighborhood, dispute notes
- `## Why it's contained` — which mechanism(s), evidence
- `## Canonical purveyors` — markdown table: Spot / Address / Notes (ratings as snapshot)
- `## Sources verified` — bulleted list of `[Name](URL) — short note`
- `## Notes for blog inclusion` — suggested section, pattern membership, cross-references

## Published-blog format (post body)

Per-entry shape in `src/content/posts/modern-forage-*/index.mdx`:
- `### <Dish> — <City/Metro>`
- Optional `*Pattern: [link to thematic post]*` line
- One long paragraph integrating origin, composition, containment, why-it-matters
- `*Sources: [Name](URL) (year, short note); [Name](URL); ...*` — inline italic block at end
- `**Where to eat:** [Spot](Google Maps URL), address (rating, brief note). [Spot](URL)...` — vendor list

## Reddit-thread voice
- The author is **u/strcrssd**.
- Their own thread comments are editorial commentary (the author's research-in-progress notes), not candidate suggestions.
- If u/strcrssd has replied (anywhere in a comment subtree) to a top-level suggestion, treat that suggestion as **already engaged** — skip from research queue.