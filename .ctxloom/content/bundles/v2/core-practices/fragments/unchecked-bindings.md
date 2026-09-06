---
tags:
  - practices
  - documentation
  - comments
  - coupling
  - maintenance
notes: |-
  Written against a specific decay mode: prose that restates something the code
  can change — a member list, a count, a supported set, a contrast with a
  sibling — is correct on the day it is written and has no mechanism to ever be
  corrected again. It does not go red when it goes false; it keeps its authority
  while lying. The expensive incident that earned the rule is recorded in the
  body: a retired rule left hand-copies of itself behind, one of which named a
  formula as the entire defense against an attack, so an auditor verifying that
  defense would have confirmed a rule the code had stopped using. The stance the
  fragment takes — describe derivable facts by relationship rather than content,
  and make anything load-bearing generated, asserted, or cited by symbol — is
  the smallest discipline that makes drift either impossible or loud.

  It also absorbs the change-history rule that once sat in the documentation
  fragment: a "Previously this was" annotation is this same decay in the past
  tense, unchecked prose competing with a record that is accurate and updates
  itself.
---
# Do not build bindings you cannot check

Naming one thing from another creates a BINDING: a coupling that has to be
maintained for as long as both sides exist. Some bindings earn that. Most do
not, and the ones that do the most damage are the ones nothing enforces.

The decisive question is not "is this true?" — you would not write it otherwise.
It is: **when this stops being true, what catches it?**

    CHECKED    a symbol reference in code; a generated table; an asserted count.
               Breaks loudly, at the moment it breaks, in front of whoever
               broke it.

    UNCHECKED  prose, comments, docs, READMEs, config annotations. Nothing
               compiles them and no test reads them. When they go false they
               do not go red — they quietly start lying, and they keep their
               authority while doing it.

An unchecked binding needs a very good reason. The default is not to create one.

## Prefer no binding at all

Most of the time the coupling is unnecessary, because the fact is DERIVABLE.
Say what the relationship IS, not what the contents currently ARE:

- "the skill(s) it carries" — not their names
- "its members", "the formats it covers", "each leg in turn"
- plural-agnostic, count-agnostic, role-descriptive

This costs nothing to write, and it cannot rot. A reader who wants the list can
produce it in seconds; they cannot recover a stale list without doing exactly
that anyway. Restating derivable state is a maintenance contract paid forever
to save someone a lookup they can do for free.

## Stress it before you write it

If you are about to name something specific, imagine the target changing in the
three ordinary ways:

- it **gains** a member
- it **loses** one
- it is **renamed**

Does your sentence go false? If yes, and nothing would catch it, you are writing
a liability. Rephrase it, or do not write it.

## The shapes this takes

Every one of these was true when written. That is the point: nothing separates a
stale one from a live one except going and checking — the work the binding was
supposed to save.

- naming the members of something: a member is added, the list is now wrong
- a census or line count: drifts on the next commit
- a listed set of supported formats or backends: one is dropped
- "unlike X, this one ..." — X is deleted, and the sentence now contrasts with
  nothing
- "see X, the live example" — X is deleted
- a rule hand-copied into several places: one copy is retired and the others
  keep asserting it. This is the expensive one. A retired rule left copies
  behind, one of which named a formula as the entire defense against an attack
  — so an auditor checking that defense would have verified a rule the code had
  stopped using, and concluded it held.

## If you must bind, make it checked

In descending order of preference:

1. **Generate it.** A table produced from the source cannot drift.
2. **Assert it.** A test that fails when the count or the set changes turns an
   unchecked binding into a checked one.
3. **Cite by SYMBOL** — a function, type, or exact string someone can grep.
   A stale symbol fails loudly the moment anyone looks; a stale line number
   silently points at unrelated code and gets believed.

"I will keep it updated" is not a mechanism. It is the absence of one, and it
has never held.

## What DOES earn an unchecked binding

Three things, and they are all judgment a reader cannot derive:

1. **A WHY.** A rationale, a constraint, a rejected alternative, a trap. "This
   is a local copy, and that is not a preference: the remote fetcher resolves a
   ref to a single file, so a directory-form bundle cannot be fetched at all."
   Nobody can compute that. It is the entire value of the comment.
2. **An invariant that genuinely depends on that exact thing** — then cite it by
   symbol, per above.
3. **A pointer somebody could not find alone**: where the authority lives, which
   of two similar mechanisms governs, what to search for.

If what you are writing is none of these, it is decoration with a maintenance
bill attached.

## History is the same mistake in the past tense

A "refactored X to Y" comment, an "Updated on ...", a "Previously this was ...",
a revision log kept inside a data file — each binds prose to a state the code no
longer has, and nothing checks it either. This one is worse than a stale list,
because version control already holds the same fact, holds it accurately, and
updates itself. Two records of one history is one too many, and the unchecked
one is the one people read.

Test it against the three exceptions above and it earns none of them: it is not
a WHY, it is not an invariant, and it is not a pointer — the pointer already
exists and it is the log. Put the reason in the commit message, where the
explanation stays attached to the change it explains.

## When you find one already stale, delete it

Prefer deleting an unmaintained list or census over correcting it. Correcting
one entry makes every remaining entry look verified, which is worse than the
honest signal that nobody is maintaining any of it.
