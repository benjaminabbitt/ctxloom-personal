---
name: admit
description: Admit work to the nightly queue — roll the live queue tag forward, triage every candidate against the unattended stop conditions, and withhold anything that cannot be finished in the dark. Use before handing over for an unattended run, when the human says "let's set up tonight's queue", "what should run overnight", "admit these", "queue this up for tonight", or asks what is in the queue. Runs WITH the human present; the unattended skill consumes what this produces.
---

# admit

This is the waking half of the unattended run. It exists because the expensive
judgement — **which work is safe to do with nobody watching** — is far cheaper
made while the human is still in the room, and because nothing else removes an
item from the queue once it is in.

You are not doing the work here. You are deciding what tonight's run is allowed
to touch, and you are doing it in the few minutes before the human leaves.

---

## The queue is a tag, and exactly one date is ever live

The queue lives in taskloom as a flat dated tag, `queue:<YYYYMMDD>`. Admission
ROLLS IT FORWARD by ADDING tonight's date to each item admitted.

    taskloom list --tag-query queue:<tonight> --compact

**Do NOT remove earlier dates.** The tag is not single-valued and it is not a
"current queue" field: a row accumulates the nights it was admitted to, and that
is its admission history. Stripping the old date destroys the only record that a
row was worked on, or waited through, a given night — and a row carrying
`queue:20260903,queue:20260904` is telling you it survived two admissions, which
is exactly the signal you want when deciding whether to admit it a third time.

**The invariant is that exactly one `queue:<date>` is the CURRENT one — tonight's
— not that a row carries only one.** Hold that deliberately, because the hazard
it guards is real and is about the QUERY, not the tags: a run that reads a date
which has passed still returns rows, still starts, and the rows are simply the
wrong ones. Nothing about it looks wrong. Guard it by querying tonight's date,
never by deleting yesterday's.

This is not hypothetical. A queue admitted on 2026-08-31 was still live on
2026-09-03 carrying fourteen items. Independent validation of all fourteen found
two that were finished or duplicated and could have been closed at any point,
three whose text made claims the code had already falsified, and six that an
unattended run **could never have done at all**. Four nights of a queue that
could not be worked, and nothing said so.

## What earns admission

An item is admitted when a GATE CAN SETTLE IT. That is the whole test, and it is
the same test the run itself will apply at 3am — better applied now, by someone
who can ask a question.

Refuse the temptation to admit something because it is important. Importance is
what makes an item worth doing; verifiability is what makes it safe to do
unattended. They are unrelated, and confusing them is how the queue fills with
work that cannot move.

## What the owner admits

A gate settling an item is necessary, not sufficient. The owner admits:

- **correctness** — the product does the wrong thing for a legitimate user;
- **security across users or accounts, or over the network** — anything another
  uid, another account, or an outside party (remote or fetched content, git
  remotes, listeners) controls;
- **chores** — duplication, wrong abstractions, shims and workarounds to replace
  with the real fix, gate gaps. Do it once, correctly; flag any row whose
  proposed fix is itself a plaster and name the correct fix.

And defers:

- **doc-only rows**, to a pre-release docs pass — code is still moving, so docs
  written now go stale (a change still fixes the docs it falsifies);
- **restrictions on the legitimate local user** — the threat model is other users
  and the network, not the user or their own agents on their own machine;
- **new capabilities** and **unruled decisions**.

Every batch goes in front of the owner for a ruling, classified and with a
one-line reason per row. The owner's ruling is the admission.

## What is withheld, and where it goes instead

**The stop conditions are defined in the `unattended` skill. Read them there.**
Do not restate them here and do not summarise them — a rule kept in two places
drifts, and the stale copy goes on being enforced while it lies.

Apply those conditions to every candidate. Anything that trips one is **NOT
admitted**. Tag it `human` so it lands in the one queue a person actually works
from, and say so in your report.

Beyond the stop conditions, withhold an item when:

- it is **blocked on another row** that has not landed — admitting it queues a
  guaranteed stall, and the run will burn its revert budget discovering that;
- it is **scoped to a different release** — a tag naming a future version is a
  statement that the work is not for now;
- **the human must look at something** for the work to be judged done: a
  rendering, a pane, an interaction. There is nobody to look;
- it needs a **live multi-process or credentialed run** the gates cannot drive.

Report each withheld item in one line: the harp, and which condition it tripped.
The human is leaving — they need the list, not the reasoning.

## Verify the candidate before admitting it

**A task's text outlives the code it describes.** Rows here have named functions
that were deleted commits earlier, and have asserted work as outstanding that
had already landed. Admitting one of those spends a night rediscovering the
present.

So for each candidate, before it goes in, spend the few seconds:

- read its `sig:` and `touches:` tags and confirm those symbols and paths still
  exist — `grep`, or `git log -S '<Symbol>'` for when something appeared or
  vanished;
- if the premise is gone, do not admit it. Correct the row, or close it.

Reaching "this is already done" or "this claim is false" is a **successful**
outcome of admission and is often worth more than admitting the item. Say so
plainly and move on.

## The exchange with the human

Lead with the recommendation, never a survey. They are trying to leave.

1. **Report the live queue's state first** — its date, its age, and what is
   still open on it. If it is stale, say so in the first sentence.
2. **Propose the carry-forward**: which unfinished items roll to tonight, and
   which you are dropping, with the one-line reason each.
3. **Propose new candidates** from the backlog, filtered as above. Name the
   source you drew from so they can redirect it.
4. **Take their ruling**, then apply the tags — add tonight's date, remove the
   previous one.
5. **Confirm the invariant**: exactly one `queue:<date>` is live, and it is
   tonight's. Verify by reading it back, not by assuming the write landed.

## What you must NOT do

- **Do not create tasks.** Admission tags existing rows. A new row needs the
  human's agreement, and the moment before they leave is the worst moment to
  negotiate one. If something genuinely needs filing, say so and let them
  decide.
- **Do not admit on your own judgement alone.** The human's ruling is the
  admission; your triage is the recommendation that informs it. This is the one
  judgement they specifically kept.
- **Do not admit an empty queue and hand over anyway.** If nothing qualifies,
  say that. A night spent on nothing is better than a night spent on work that
  will be reverted.

## Handing over

When the tags are applied and read back, say what the run is authorized to do:
the count admitted, the count withheld, and the exact query the run will use.
Then hand off to the `unattended` skill, which owns everything from pre-flight
onward.
