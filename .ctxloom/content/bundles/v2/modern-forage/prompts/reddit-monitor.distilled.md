---
distilled_by: claude-haiku-4-5-20251001
---
# reddit-monitor

Process Reddit food threads for Modern Forage candidates via containment test, research, cited decisions.

**Input:** Reddit post URL (old.reddit.com preferred). STOP if missing.

**Load:** containment-criteria, disposition-rubric, editorial-voice fragments.

## Step 1 — Fetch thread

```
curl -sL -A "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36" "<url>.json"
```

Extract: post (id, title, selftext, permalink), top-level comments (id, author, body, permalink), recursive u/strcrssd-authored replies.

## Step 2 — Locate matching draft + load state

Identify matching Modern Forage post on ben.abbitt.me. If ambiguous, list candidates and ask.

Read once:
- `src/content/posts/modern-forage-*/index.mdx`
- `subprojects/modern_forage/dishes/regional-cuisine-research-tracker.md`
- `subprojects/modern_forage/dishes/hyper-local-us-regional-cuisines.md`

## Step 3 — Delta check

State file: `subprojects/modern_forage/research-logs/reddit-<post-id>.md`

Read "Processed comment IDs" if exists; skip already-processed. Otherwise fresh run.

## Step 4 — Filter working set

- **Skip** — u/strcrssd replied in subtree; record strcrssd permalink
- **Collect** — u/strcrssd top-level or reply comments (permalink + summary)
- **Discard** — jokes, emojis, off-topic, brand-only; record in "Filtered noise" section with links

Remaining top-level comments = candidate set.

## Step 5 — Cross-check tracker

Per candidate, search tracker + survey:
- **ALREADY COVERED** — note file+section; skip
- **DEFERRED** — note reason; re-research only if comment adds evidence addressing deferral
- **EXCLUDED** — note reason; re-research only if comment counters reason
- Else — queue for research

## Step 6 — Research candidates

WebSearch + WebFetch. **5+ independent named sources** (food media, local TV, longform journalism, academic, oral histories — NOT Reddit/single reviews).

Per candidate:
- **What it is** — one paragraph, structure
- **Origin** — year, neighborhood, figure, disputes
- **Containment evidence** — mechanism(s), spread, diaspora, media volume, name recognition
- **Sources** — 2-8 URLs with notes

Apply 4-factor test (containment-criteria) → classify per disposition-rubric: PROMOTE / PROMOTE WITH CAVEAT / DEFER / EXCLUDE / ALREADY COVERED / PROMOTION CANDIDATE. Each needs explicit one-line reason.

## Step 7 — Write outputs

### A. Research log

Path: `subprojects/modern_forage/research-logs/reddit-<post-id>.md`

First run, create:

```markdown
# Reddit thread research log: <post-id>

**Thread:** [<title>](<post URL>)
**First processed:** <YYYY-MM-DD>
**Last processed:** <YYYY-MM-DD>
**Processed comment IDs:** <id1>, <id2>, ...

## Editorial commentary (u/strcrssd)
- [<permalink>] — <summary>

## Already-engaged comments
- <user> [<permalink>]: <suggestion> — strcrssd reply: [<permalink>]

## Filtered noise
- <user> [<permalink>]: <reason>

## Candidates

### <Dish> — <City> [<DISPOSITION>]
**Suggested by:** [<user>](<permalink>)
**Disposition reason:** <one line>

**What it is:** ...
**Origin:** ...
**Containment evidence:** ...
**Sources:**
- [Name](URL) — note
...

**Action:** <staged | track at <path:line> | research more | exclude on <reason>>
```

Re-run: append new candidates/commentary; update dates and comment IDs.

### A2. Drafted replies

One per PROMOTE/CAVEAT commenter. Draft brief reply in strcrssd's voice:
- 40-80 words
- **CRITICAL: Wrap body in code block (triple backticks) — preserves markdown link syntax for Reddit paste**
- Flush-left, no indentation/blockquotes inside fence
- Cite 2-4 sources via `[text](url)` (pick load-bearing: historians, key facts, canonical histories; skip menus)
- No em-dashes
- Acknowledge counter-commenters by handle if resolving counter-evidence (Reddit auto-links)
- Close: "Going in [iteration]." or equiv.

One reply per commenter; multiple PROMOTEs in one comment = one reply addressing all. No reply for EXCLUDED unless strcrssd already replied (then follow-up).

### B. Staged dish files

Path: `subprojects/modern_forage/dishes/_pending/<slug>.md`

Use editorial-voice format. Frontmatter + sections (What it is / Origin / Why contained / Canonical purveyors / Sources verified / Blog notes).

For CAVEAT: add `caveat: <reason>` to frontmatter + blockquote in body.

Only for PROMOTE-classified. Skip DEFER/EXCLUDE/ALREADY COVERED/PROMOTION CANDIDATE.

### C. Punch list (user-facing stdout)

**ALWAYS emit.** Final action after logs + files.

```
## Reddit thread: <title>
<post URL>
Processed: <N> comments (<M> new, <K> existing)

### Editorial commentary (u/strcrssd)
- <id> (top-level | reply): <bare URL> — "<snippet>"

### New candidates — PROMOTE (<n>)

1. **<Dish>** (<city>) — ✅ PROMOTE
   Suggested by **u/<author>**: <bare URL>
   [Reinforced by **u/<other>**: <bare URL>]
   [Counter-evidence from **u/<author>**: <bare URL> — <resolution>]
   Why: <one-line reason; cite source count + evidence>
   Action: staged at `subprojects/modern_forage/dishes/_pending/<slug>.md`

### New candidates — PROMOTE WITH CAVEAT (<n>)
[same, caveat explicit]

### New candidates — DEFER (<n>)

1. **<Dish>** (<city>) — ⏸ DEFER
   Suggested by **u/<author>**: <bare URL>
   Why: <reason>
   Unlock: <research mechanism>

### Already covered (skipped)
- **u/<author>** — <dish>: <bare URL> → <file>:<line>

### Excluded
- **u/<author>** — <dish>: <bare URL> — <reason>

### Filtered noise
- **u/<author>**: <bare URL> — <reason>

### Already engaged (skipped)
- **u/<author>** — <dish>: <bare URL> — strcrssd reply: <bare URL>

### Promotion candidates (hyperlocal → regional)
- <Dish> in <post> as <city>; surfaced <other metro> via **u/<author>**: <bare URL>
[None surfaced this run.]

### Suggested replies

**Reply to u/<author>** — <bare URL>

<reply text with inline [link](url)>

---
```

Structural rules:
- PROMOTE first after editorial
- Handles as **u/<name>** (bold)
- Permalinks as bare URLs
- All dispositions show commenter; PROMOTE gets extra visibility
- Empty sections: "[None surfaced this run.]"

## Monitoring

Re-run same URL to pick up new comments. Log tracks processed IDs.

Continuous: `/loop 1h /forage:reddit-monitor <url>`
Or: `/schedule`

## Operating rules

- **Always emit punch list to stdout** as final action. User reads punch list, not files.
- **Surface permalinks for all dispositions.** User needs to thank/follow up contributors.
- **Don't write directly** to canonical survey or blog. Skill = research only; human = curator.
- **5+ sources minimum** for PROMOTE. Below 5 = DEFER + note unlock condition.
- **No em-dashes** (editorial-voice rule).
- **Cite everything.** Every reason traces to source URL, tracker line, or post line.