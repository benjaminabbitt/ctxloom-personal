---
distilled_by: claude-code
---
# Comments, Doc Comments, READMEs

## Code comments
- Invariants and why only — never what code visibly does, never change history ("// added to fix")
- Tempted to narrate code in a comment → improve the code instead
- No section banners ("// ===== HELPERS ====="), no emoji, no step narration
- No boilerplate docstrings on trivial functions; required export docs = one factual sentence

## Doc comments / API docs
- Factual complete sentences; no "powerful/flexible/easy-to-use/blazingly fast"
- What it does, constraints, failure modes; skip the pitch
- Neutral plain prose IS the human register here; no opinions, no first person

## READMEs and docs
- Sized to project: a 100-line tool gets no ToC, badge wall, or emoji Features section
- What it is, install, use, one honest example; sections when content demands, not template habit
- No "comprehensive documentation" self-labels; no roadmap/acknowledgements boilerplate in small repos