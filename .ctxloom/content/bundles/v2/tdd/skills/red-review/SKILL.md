---
name: red-review
description: Before implementing anything test-first, write the red tests, commit them red, and get them REVIEWED BY THE HUMAN, then implement against them. Use at the start of any implementation, feature, bug fix that changes behaviour, or dispatched implementer brief; and during admission for an unattended run, where every admitted item's red tests are written and reviewed before the human leaves.
metadata:
  type: workflow
---

# Red tests are the spec; the human reviews the spec

When you begin implementing anything, the first deliverable is the red
tests, and the human reviews them BEFORE a line of implementation exists.

## Why

The failing tests are the cheapest complete statement of what is about to
be built: the signatures, the contract, the refusals, the edge cases. Read
in a red commit, each is a proposal that costs one edit to change. Read
inside a finished implementation, each is a fait accompli that costs a
refactor to argue with. `design-by-test` explains why the test is where the
design is decided; this skill adds who signs it off, and when.

An implementation that passes tests nobody reviewed proves only that the
code agrees with itself.

## The rule

1. **Write the red tests** that pin the behaviour: the happy path, every
   refusal, the edge cases you can name. Use stubs (`todo!()`,
   `unimplemented!`, `compile_error!`) where needed to compile. Watch each
   test FAIL for the reason it should, not for a typo.
2. **Commit them red, on their own branch.** If the pre-commit hook runs the
   tests, skipping it for THIS commit is the human's call, so ask. Name the
   skip in the commit message.
3. **Put them in front of the human**, with the interactive question tool:
   what each test pins, the design choices it embodies, and the questions
   you could not settle (an unwritable test is an open question; raise it,
   don't guess). Point at the commit, not at prose.
4. **Implement only after they approve.** Their changes go into the tests
   first, then the code.
5. **Don't edit a reviewed test's assertions to make it pass.** If the
   implementation shows a reviewed test is wrong, that's a finding: stop
   and bring it back to the human. Fixing a test that doesn't compile, or
   its setup, is fine; changing what it asserts is not.

## Scope

- Applies to new behaviour, changed contracts, and bug fixes that change
  what the code does.
- Does NOT apply to pure refactors under existing coverage, deletions,
  renames, comments or docs. There is no new spec to review.
- A bug's reproduction test pins behaviour the code already claims to
  have, so it doesn't need review before the fix. Report it with the fix.

## Dispatching

The brief names the reviewed red commit as the spec and carries rule 5:
the implementer makes those tests pass and escalates rather than editing
their assertions. A brief that says "write tests and implement" produces
implementation-first work with tests appended. If the red tests aren't
reviewed yet, dispatch the red-writing alone and stop there.

## Unattended runs

Nobody reviews at 3am, so the review happens at ADMISSION: `admit` writes
and reviews every admitted item's red tests while the human is present, and
`unattended` implements only against them. An item whose red tests can't be
written yet isn't ready to admit.
