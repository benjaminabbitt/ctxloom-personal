---
tags:
  - coordinator
  - prompt-writing
notes: |
  Why: a sub-agent sees nothing but its brief, and the recurring
  failure is a brief written as if the child shared the
  coordinator's context — missing goal, scope, output contract, or
  stop condition, so the child guesses and the guess is discovered
  at integration. The slow-command section carries the expensive
  lesson: a command that outruns the tool timeout is
  auto-backgrounded, and a leaf agent is never re-invoked, so it
  waits forever while the harness reports it completed. Prohibiting
  that in prose was tried and measured to make the stall rate
  worse, which is why the section demands a structural fix — hand
  implementers only gates fast enough that the stall cannot happen
  — rather than stronger wording. The figures in the body are those
  measurements, not rhetoric.
---
# Writing prompts for sub-agents

A sub-agent sees only the prompt you give it — not your context,
not the conversation. Write the prompt as a self-contained
briefing.

## Every sub-agent prompt states
- The GOAL: what to accomplish, and why (enough context for the
  agent to make judgment calls).
- The SCOPE: what is in and out of bounds; where to look; what to
  ignore.
- The OUTPUT CONTRACT: exactly what to return and in what shape —
  paths and line numbers, a structured list, a diff, a yes/no with
  evidence. When you want the conclusion and not the raw material,
  say "do not dump whole files; return paths + concise findings."
  Always include: file agent_report(scope FINAL) before finishing
  — that report IS the deliverable, not a courtesy message.
- The STOP condition: when the agent is done.
- DEFERRED WORK: require the FINAL report to name anything
  deferred, skipped, or left out of scope — explicitly, even when
  the honest answer is "nothing left." Deferrals belong in the
  report TEXT, not a side channel. You, the coordinator, RAISE
  each one with the human; neither you nor the child files a task
  unprompted, and a row is created only once the human accepts it.
  The child never writes the task log itself.

## Match the prompt to the role
- Finder prompts are tight and lookup-shaped: "locate X, report
  path:line."
- Implementer prompts define the change and the escalation rule:
  "make X; escalate to me before changing any interface, contract,
  or cross-module structure."
- Reviewer prompts name the lens and the severity bar.

## Adversarial framing where it helps
For verification, instruct the agent to try to REFUTE a claim, not
confirm it — "find a case where this breaks" surfaces more than
"check that this works." Prefer independent verification over
self-review.

## NEVER put a slow command in an implementer brief

The most common way a sub-agent fails is not a bad edit — it is
stalling forever on a command that outran its tool timeout.

The mechanism: a harness Bash tool has a default timeout (commonly
120s). A command that exceeds it gets AUTO-BACKGROUNDED, and the
tool tells the agent it will be notified on completion. That is
true for the MAIN loop, which gets re-invoked. It is FALSE for a
sub-agent: a leaf that ends its turn is done, and nothing ever
re-invokes it. It waits forever, its deliverable never sent, while
the harness reports it `completed`.

**Forbidding this in prose does not work — it has been measured.**
In one 14-agent wave: briefs with no prohibition stalled 1 of 6;
briefs carrying an explicit "never background a command, never arm
a monitor, never poll" stalled 4 of 7. It got WORSE. Wording is not
the variable. The variable is a gate that takes 123s against a 120s
timeout — three seconds over, so build-cache state alone decides,
which is exactly why the failure looks random and why no amount of
emphasis moves it.

So fix it structurally, not verbally:

1. **MEASURE your project's gate commands before writing any brief**
   (`s=$(date +%s); <cmd>; echo $(( $(date +%s) - s ))`). You cannot
   reason about this without the numbers.
2. **Give implementers only the fast, NARROW gates** — the
   per-package test target, a repo-wide vet, the linter. Seconds,
   not minutes. The stall then cannot happen.
3. **Run the full suite and the acceptance suite YOURSELF at merge
   time.** You are already forbidden from closing anything on an
   agent's reported exit code, so the agent's full-suite run was
   always duplicated work whose only unique effect was to strand it.
4. If a long command is genuinely unavoidable, name an explicit
   large `timeout` on that single call in the brief.

State the reason in the brief, not just the rule — an agent told
"you will not be notified, and five agents have been lost this way"
complies far better than one handed a bare prohibition.

**The trade-off is real and you own it:** an implementer that cannot
run the acceptance suite cannot settle a row whose fix changes
acceptance behaviour. Expect those rows back as escalations, and
settle them yourself on your own merge-time run. That is the correct
division — it is also cheaper than a stalled agent.

Regardless of wording, the coordinator-side defences still hold:
treat a "completed" agent whose result is a sentence about waiting
as ALIVE-BUT-STUCK; inspect its worktree before retrying or reaping;
and require commit-after-every-unit, which is what makes a stall
survivable rather than fatal.