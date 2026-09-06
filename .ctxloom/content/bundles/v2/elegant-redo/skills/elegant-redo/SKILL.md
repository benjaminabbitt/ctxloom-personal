---
name: elegant-redo
description: Rebuild an implementation from scratch using what the first attempt taught, instead of patching it further. Use when code works but fights its own shape — accumulated patches have buried the design, the abstraction no longer matches the problem you now understand, or you catch yourself adding a special case to preserve a structure you would not choose today. Also when the user asks for a fresh take, a rewrite, or says the current approach feels forced.
---

# Elegant redo

The first implementation teaches you the problem. The second one solves it.

What a first attempt is worth is the KNOWLEDGE it produced — the hidden
requirements, the edge cases that surprised you, the constraints the problem
turned out to impose. That is the output worth keeping. The code is the
byproduct, and it is usually shaped by what you believed before you knew any of
it.

This is not refactoring. Refactoring preserves structure and improves it. This
discards the structure, because the structure is the thing that is wrong.

## Before deleting anything, write down what you now know

Do this FIRST and in writing. It is the whole reason the rebuild beats the
original, and it is the part that evaporates if you start typing code.

- Requirements you discovered that nobody stated up front
- Edge cases that surprised you, and what each one forced
- Constraints the problem imposes — ordering, concurrency, failure modes
- Interfaces and contracts that must survive, because callers depend on them
- What was genuinely right, conceptually, and should reappear in some form
- What turned out to be over-built, speculative, or solving a problem you
  invented

If you cannot produce this list, you have not learned enough yet. Keep working
on the current code until you can.

## Find the shape the problem actually has

With that list in front of you, and not before:

- What is the simplest structure that covers every case on it?
- What data shape does the problem suggest, rather than the one you picked?
- Where was the first attempt fighting the language, the framework, or an
  existing seam instead of using it?
- What can be deleted outright, rather than carried across?

## Rebuild clean

- Do not copy-paste from the old implementation. Reading it is fine; pasting it
  imports the shape you are trying to escape, and it will pull the rest of the
  old design in behind it.
- Let the structure follow the problem, not the previous solution.
- Keep the TESTS. They encode requirements, which survive; the implementation
  does not. Rewrite a test only when the first attempt taught you it asserted
  the wrong thing.

## Prove it was worth doing

A redo that is merely different is a waste. Show it is better, concretely:

- every edge case from the inventory is handled, and demonstrably so
- the tests pass — the same ones, or ones you can justify having changed
- it is measurably smaller or simpler: fewer lines, fewer abstractions, fewer
  branches, a flow you can follow without a diagram

If none of those hold, the honest move is to stop and keep the original. Say so
plainly rather than shipping a lateral rewrite.

## When NOT to do this

- The code is merely unfamiliar or not to your taste. That is not a reason.
- You cannot yet state what the first attempt taught you.
- The implementation is load-bearing and you have no tests. Write the
  characterization tests first, or you are rebuilding blind.
- The cost lands on someone else — a contract others depend on, a migration you
  are not the one paying for. Surface that decision instead of taking it.

## The trap this exists to defeat

The reason to reach for this deliberately is that the pull runs the other way:
work already done feels like a reason to keep it. It is not. See the
`sunk-cost` fragment in `developer-mindset` — existing code earns its place by
what it buys now, and the effort behind it is spent either way.
