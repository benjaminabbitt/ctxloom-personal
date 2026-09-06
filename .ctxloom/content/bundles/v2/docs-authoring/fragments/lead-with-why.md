---
tags:
  - writing
  - docs
  - structure
notes: Standard held by the author across every hand-written page of the ctxloom docs site; the Session Memory page is the exemplar. Promoted here from a personal note so it survives outside one person's head. Pairs with the humanizer bundle's `formatting` fragment, which governs prose-vs-bullets; this one governs order.
content_hash: sha256:a1122738d0881407260c2eed59063b10b53023020efc3e355cbe2c6fbb9327e9
---
# Lead with why

Every hand-written docs page opens with the pain and the payoff. Mechanism comes last. A reader who stops after the first paragraph should still know whether this page is for them.

## The order

**Impactful → useful → detail.** Never the reverse.

1. **The pain.** What goes wrong without this. Name it concretely — the failing command, the lost work, the wasted tokens. Not "context management is important."
2. **The payoff.** What you get instead, in one sentence a reader can repeat to a colleague.
3. **The shape.** How it works, at the altitude of a diagram or a three-step flow.
4. **The detail.** Flags, keys, schemas, edge cases. This is where reference material lives, and it is the part most readers will skip — which is fine, because they got what they came for above it.

The instinct to define your terms before using them is the enemy here. A page that opens with "A fragment is a unit of context" has told the reader nothing about why they should care. Open with the problem fragments solve; the definition can wait three paragraphs, and by then the reader wants it.

## What this rules out

- Opening with a definition, a taxonomy, or a "Concepts" preamble.
- Opening with installation or syntax. Nobody installs a thing they aren't yet sold on.
- Burying the motivating example below the reference table.
- A "Why?" section placed *after* the "How?" section. If you find yourself writing one, it belongs at the top and it isn't a section, it's the opening.

## Exempt

Generated reference (CLI pages, schema dumps, tool listings). Those exist to be indexed and grepped, not read start to finish. Do not retrofit narrative onto them — and do not hand-edit them at all.