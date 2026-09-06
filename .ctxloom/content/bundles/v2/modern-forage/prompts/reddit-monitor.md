---
description: Process a Reddit thread for Modern Forage candidates with cited decisions
tags:
  - modern-forage
  - research
  - reddit
content_hash: sha256:b0b85be1d108ed206bf9d5b426ac63634a0b8c90fec4af4fe195e27214e3892f
---
Process a Reddit food thread for Modern Forage candidates. Apply the containment test, do real research, produce cited decisions.

User input: $ARGUMENTS — a Reddit post URL (preferably old.reddit.com).

If no URL is supplied, STOP and ask.

Methodology context to load: see fragments `containment-criteria`, `disposition-rubric`, `editorial-voice`.

## Step 1 — Fetch the thread

Fetch the thread JSON: `curl -sL -A "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36" "<url>.json"`. Parse with python.

Extract:
- Post: id, title, selftext, permalink
- Each top-level comment: id, author, body, permalink (`https://old.reddit.com{permalink}`)
- Recursive replies — at minimum walk the subtree looking for u/strcrssd-authored comments

## Step 2 — Locate matching draft + load tracker state

The post or its comments likely reference a Modern Forage post on ben.abbitt.me. Identify the matching post.

If ambiguous (multiple posts could match), list candidates and ask which to compare against.

Read once at start:
- The matching `src/content/posts/modern-forage-*/index.mdx`
- `subprojects/modern_forage/dishes/regional-cuisine-research-tracker.md` (current promotion/exclude/defer state)
- `subprojects/modern_forage/dishes/hyper-local-us-regional-cuisines.md` (already-covered entries)

## Step 3 — Re-run delta check

State file: `subprojects/modern_forage/research-logs/reddit-<post-id>.md`.

If the file exists, read its "Processed comment IDs" list. Skip any comment IDs already there. Only process the delta.

If the file doesn't exist, this is a fresh run.

## Step 4 — Filter the working set

Build the candidates list from top-level comments:

- **Skip (already engaged)** — if u/strcrssd has replied anywhere in the comment's subtree. Record the strcrssd permalink alongside.
- **Collect (editorial commentary)** — every u/strcrssd-authored comment (top-level or reply), with permalink and body summary.
- **Discard (noise)** — pure jokes, single-emoji or ack reactions, off-topic, brand-only mentions without a dish. Note discarded items briefly with permalinks in a "Filtered noise" section so the user can reconsider.

The remaining top-level comments are the candidate set.

## Step 5 — Cross-check tracker before researching

For each candidate, search the tracker text + canonical survey for matching entries:
- **ALREADY COVERED** — note where (file + section); skip fresh research.
- **DEFERRED with reason** — note prior reason; only re-research if the comment specifically presents new evidence that addresses the deferral cause.
- **EXCLUDED with reason** — note prior reason; only re-research if the comment specifically counters that reason.
- Otherwise — queue for fresh research.

## Step 6 — Research each new candidate

Use WebSearch + WebFetch. **Target 5+ named independent sources** per the source threshold. Sources should be food media, local TV, longform journalism, academic, oral histories — NOT Reddit, NOT single user reviews.

Capture per candidate:
- **What it is** — one paragraph, structural composition
- **Origin** — year, neighborhood, founding figure if known, dispute notes
- **Containment evidence** — which mechanism(s), geographic spread, diaspora signal, media coverage volume, name-recognition test
- **Sources** — list of 2-8 cited URLs with one-line notes

Apply the 4-factor selection test (containment-criteria fragment) and classify per the disposition-rubric: PROMOTE / PROMOTE WITH CONTAINMENT CAVEAT / DEFER / EXCLUDE / ALREADY COVERED / PROMOTION CANDIDATE.

Each classification needs an explicit one-line reason.

## Step 7 — Write outputs

### A. Research log (always written)

Path: `subprojects/modern_forage/research-logs/reddit-<post-id>.md`

On first run, create with:

```markdown
# Reddit thread research log: <post-id>

**Thread:** [<title>](<post URL>)
**First processed:** <YYYY-MM-DD>
**Last processed:** <YYYY-MM-DD>
**Processed comment IDs:** <id1>, <id2>, ...

## Editorial commentary (u/strcrssd)
- [<permalink>] — <one-line summary>

## Already-engaged comments (u/strcrssd replied)
- <user> [<permalink>]: <suggestion> — strcrssd reply: [<permalink>]

## Filtered noise
- <user> [<permalink>]: <reason — joke / brand / off-topic>

## Candidates

### <Dish> — <City> [<DISPOSITION>]
**Suggested by:** [<user>](<comment permalink>)
**Disposition reason:** <one line>

**What it is:** ...

**Origin:** ...

**Containment evidence:** ...

**Sources:**
- [Name](URL) — note
- [Name](URL) — note
- ...

**Action:** <staged at <path> | track at <existing entry path:line> | research more by <mechanism> | exclude on grounds of <reason>>
```

On re-run, **append** new candidates and editorial commentary; update Last processed and Processed comment IDs.

### A2. Drafted replies (one per commenter who contributed a PROMOTE or PROMOTE-WITH-CAVEAT)

For each commenter whose suggestion produced a PROMOTE (or CAVEAT) classification, draft a brief Reddit reply in strcrssd's voice. Constraints:

- **Brief.** 40-80 words. Reddit-comment length.
- **CRITICAL: Wrap each reply body in a fenced code block** (triple backticks). The Claude Code renderer auto-converts inline `[text](url)` to clickable links, which strips the bracket syntax on copy. The code block preserves the literal markdown source so the user can copy-paste it into Reddit's editor with link syntax intact.
- **Plain text inside the code block, no blockquote indentation, no leading spaces.** Every line of the reply body must start flush-left inside the code fence.
- **Inline markdown citations.** Cite 2-4 sources via `[link text](url)` syntax. Pick the most load-bearing sources (food-historian posts, smoking-gun containment facts, canonical brand histories). Don't bother citing primary-source restaurant menus.
- **No em-dashes** — strcrssd's voice rule.
- **Acknowledge counter-commenters explicitly** if the disposition involved resolving counter-evidence. Name them by handle. Reddit auto-links usernames.
- **Close with intent.** End with "Going in [next iteration]." or equivalent.

For commenters who contributed multiple PROMOTEs in one comment, write one reply that addresses all of them. For commenters whose suggestion was EXCLUDED, no reply is drafted by default. If strcrssd already replied in the thread, the new reply is a follow-up that closes the loop.

### B. Staged dish file (one per PROMOTE-classified candidate)

Path: `subprojects/modern_forage/dishes/_pending/<slug>.md`

Use the per-dish format from the editorial-voice fragment. Frontmatter, then full body sections (What it is / Origin / Why it's contained / Canonical purveyors / Sources verified / Notes for blog inclusion).

For PROMOTE WITH CONTAINMENT CAVEAT, add `caveat: <one-line reason>` to frontmatter and include the caveat blockquote in the body.

Do NOT stage files for DEFER, EXCLUDE, ALREADY COVERED, or PROMOTION CANDIDATE.

### C. Punch list (stdout, the user-facing summary — MANDATORY)

This is the final user-facing output of the run. Always emit it. Always include comment permalinks as bare URLs (not markdown link text) so they're clickable in any terminal renderer. For each PROMOTE specifically, surface the commenter handle (`u/<name>`) prominently — the user wants to be able to thank or follow up with the original commenter, so the link must be impossible to miss.

```
## Reddit thread: <title>
<post URL>
Processed: <N> comments (<M> new this run, <K> already in log)

### Editorial commentary (u/strcrssd)
- <comment id> (top-level | reply to <parent user>): <bare permalink URL> — "<verbatim quoted snippet>"

### New candidates — PROMOTE (<n>)

1. **<Dish>** (<city>) — ✅ PROMOTE
   Suggested by **u/<author>**: <bare permalink URL>
   [Reinforced by **u/<other author>**: <bare permalink URL>]
   [Counter-evidence from **u/<author>**: <bare permalink URL> — <one-line resolution>]
   Why: <one-line classification reason; cite source count + key containment evidence>
   Action: staged at `subprojects/modern_forage/dishes/_pending/<slug>.md`

### New candidates — PROMOTE WITH CONTAINMENT CAVEAT (<n>)
[same shape, with the caveat explicit]

### New candidates — DEFER (<n>)
1. **<Dish>** (<city>) — ⏸ DEFER
   Suggested by **u/<author>**: <bare permalink URL>
   Why: <reason — typically under-sourced>
   Unlock condition: <what additional research mechanism would promote this>

### Already covered (skipped fresh research)
- **u/<author>** — <dish>: <bare permalink URL> → already in <file>:<line>

### Excluded
- **u/<author>** — <dish>: <bare permalink URL> — <exclude reason>

### Filtered noise
- **u/<author>**: <bare permalink URL> — <reason: joke / off-topic / etc.>

### Already engaged (skipped per skip-rule, unless overridden by user)
- **u/<author>** — <dish>: <bare permalink URL> — strcrssd reply at <bare permalink URL>

### Promotion candidates (hyperlocal → regional)
- <Dish> currently in <post> as <city>-locked; this thread surfaces it in <other metro> via **u/<author>**: <bare permalink URL>.
[None surfaced this run.] — emit if empty

### Suggested replies (copy-paste ready)

For each commenter who contributed a PROMOTE or PROMOTE-WITH-CAVEAT. Plain text, no blockquote indentation, inline markdown link citations.

**Reply to u/<author>** — <bare permalink URL>

<reply text with inline [link text](url) citations to 2-4 load-bearing sources>

---

**Reply to u/<other author>** — <bare permalink URL>

<reply text>
```

Required structural rules:
- The PROMOTE section comes FIRST after editorial commentary, not buried below the noise
- Every commenter handle is rendered as `**u/<name>**` (bold) so it stands out
- Every permalink is emitted as a bare URL, not wrapped in markdown link syntax — easier to copy
- Include the suggesting commenter for ALL dispositions (not just PROMOTE), but PROMOTE entries get extra visibility (Reinforced by / Counter-evidence from sub-bullets)
- If a section has no entries, emit "[None surfaced this run.]" — never silently omit a section

## Monitoring

Re-run the same skill against the same URL to pick up new comments. The research log records processed comment IDs, so each run only handles the delta.

For continuous monitoring, wrap with /loop:

```
/loop 1h /forage:reddit-monitor https://old.reddit.com/r/cincyeats/comments/...
```

Or use /schedule for cron-driven runs.

## Operating rules

- **Always emit the punch list to stdout** as the final action of the run, after writing the research log and any staged files. Never end a run without it. The user is reading the punch list, not the file system.
- **Surface commenter permalinks for every disposition,** not just PROMOTE. The user wants to be able to click through to thank, follow up with, or reply to any commenter who contributed a suggestion that was acted on.
- **Don't write entries** to the canonical survey or blog post directly. The skill is a research assistant; the human stays in the curatorial seat.
- **Don't promote without 5+ named sources.** If you can't reach 5, classify as DEFER and note what additional research mechanism would unlock promotion.
- **No em-dashes** in any user-facing prose (per editorial-voice).
- **Cite everything.** Every disposition reason must trace to either a source URL, a tracker line, or a published-post line.