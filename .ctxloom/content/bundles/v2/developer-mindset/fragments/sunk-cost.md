---
tags:
  - workflow
  - refactoring
  - quality
---
# Sunk cost: don't

We do not preserve things because they are written.

Existing work is not an argument for keeping it. The only questions are what it
buys NOW and what it costs to carry from here.

## The tell

You are arguing from sunk cost whenever the case for keeping something is a
fact about its HISTORY rather than its value:

- "it already exists and works"
- "it's already tested and green"
- "we already paid for this"
- "someone put real effort into this"

Every one of those can be true while the thing still fails to earn its place.

## The question that settles it

**If it did not exist, would you write it today for what it buys?**

If the honest answer is no, delete it. The effort is spent either way. The only
decision still open is whether to keep paying to carry the result.

Answer it with a measurement where you can. "It saves some calls" loses to "it
saves four calls a session, against two lookup tables nothing validates".

## It applies past code

Prose, plans, tests, config keys, abstractions, whole features. A test that
proves nothing does not earn its place by being green. A doc nobody maintains
does not earn its place by having been written. An abstraction with one caller
does not earn its place by having been designed.

Deleting is not the waste. Carrying something that does not earn its place is,
and unlike the original effort that cost is still ahead of you.

## Watch for it in your own recommendations

The failure is rarely someone defending old code on principle. It is a
recommendation whose real support is that the work is already done, dressed up
as a judgement about value. When you catch yourself recommending "keep" and the
strongest thing you can say is that it already works, you have found one.

See also elegant-redo, for what to do with what a discarded attempt taught you
— the knowledge is the output worth keeping, not the code.