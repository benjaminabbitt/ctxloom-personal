---
distilled_by: claude-haiku-4-5-20251001
---
# editorial-voice

**Author standards**
- No em-dashes in prose (minimize AI tells); chat exempt
- "Common knowledge inside, blank stare outside" / blank stare 200 miles test
- Diaspora signal = highest-trust lead
- Single-restaurant entries only if structural lock explicit & load-bearing
- Brand-substituting-for-dish: must appear on multiple menus

**Staged-file format**

`subprojects/modern_forage/dishes/<slug>.md` or `_pending/<slug>.md`

```yaml
slug: <city>-<dish>
title: <Dish> — <Region>
city: <city>
state: <state>
neighborhood: <if applicable>
year_established: <year|"1950s"|"disputed">
status: active|geographically locked|~N years
threshold_met:
  - geographic_containment: true|false
  - name_recognition_failure: true|false
  - no_national_chain_adoption: true|false
  - active_local_culture: true|false
seed_source: /r/<subreddit> thread, <Month YYYY>
last_verified: <YYYY-MM-DD>
```

Body sections (in order):
- `# <Dish>`
- `## What it is` — structural composition (1 para)
- `## Origin` — year, founder, neighborhood, disputes
- `## Why it's contained` — mechanism(s) + evidence
- `## Canonical purveyors` — Spot | Address | Notes
- `## Sources verified` — `[Name](URL) — note` list
- `## Notes for blog inclusion` — patterns, cross-refs

**Published-blog format**

`src/content/posts/modern-forage-*/index.mdx`

- `### <Dish> — <City/Metro>`
- `*Pattern: [link]*` (optional)
- Paragraph: origin, composition, containment, significance
- `*Sources: [Name](URL) (note); ...*` (italic)
- `**Where to eat:** [Spot](Maps URL), address (rating, note). [Spot](URL)...`

**Reddit-thread voice**

- Author: u/strcrssd
- Comments = editorial/research notes only, not suggestions
- If u/strcrssd replied anywhere in subtree: mark **already engaged**, remove from queue