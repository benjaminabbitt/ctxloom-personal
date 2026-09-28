---
name: reuse-before-write
description: Before adding a new function, method, struct, type or helper, look for existing code that already produces the effect you need — including private, unexported and test-only code. Use whenever you are about to write a new unit of code, and before dispatching an implementer to write one. A second need for a private helper is the signal to raise it, not to copy it.
metadata:
  type: workflow
---

# Look for it before you write it

Every new function is a second implementation of something until proven
otherwise. Two implementations of one behaviour drift: one gets the bug fix,
the other keeps the bug, and nothing tells you which is which.

So before writing a new unit of code, spend a few minutes proving it doesn't
already exist.

## 1. Name the effect, not the function

Write one sentence saying what the code must DO — its behaviour, its inputs,
its result. Not the name you were about to give it. Names differ between
authors; effects don't. "Turn a Windows host path into the path a Linux
container sees" finds code that `mapPath`, `toContainer` and `translate` all
might be.

## 2. Search by behaviour, everywhere

- Grep for the operations the effect needs, not the name you'd choose: the
  stdlib calls, the syscalls, the file names, the error text it would produce.
- Search private and unexported code. An unexported helper in another package
  is still an implementation.
- Search test helpers and test-support packages. A fake that already does it is
  half of a real implementation.
- Ask whether it's a standard: the stdlib, a dependency already in the module,
  a documented convention.
- Use the symbol search you have (serena, an LSP, `git grep`). Don't stop at the
  first miss; try two or three phrasings of the effect.

## 3. Decide from what you found

- **It exists and you can reach it:** use it.
- **It exists but is private or unreachable:** a second need is the signal to
  RAISE it. Move or export it to the lowest place both callers may import, keep
  ONE implementation, and repoint the original caller. Never copy it. Raising
  changes a package's surface, so present the new signature before doing it,
  and check the layering rules allow the new import.
- **Something close exists:** extend or parameterize it rather than forking a
  near-copy. If extending would distort it, say why before writing a new one.
- **Nothing exists:** write it — and write down what you searched.

## 4. Say what you searched

In the plan, the brief or the report, state the effect you looked for, where
you looked, and what you found: reused, raised, extended, or nothing. "Searched
for X in A and B; found C (unexported), raised it" lets a reviewer check your
work in seconds. A new function with no search behind it is a claim nobody can
verify.
