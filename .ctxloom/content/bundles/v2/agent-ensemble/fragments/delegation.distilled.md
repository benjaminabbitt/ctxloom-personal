---
distilled_by: claude-opus-5-5
---
# Delegation: keep your context lean

Your context is scarce. Delegate any work that would consume meaningful
context or is better done by a specialist, then integrate the result.

## Delegate to the finder (cheap, parallel)
- File reads; code, symbol and definition lookups; config values;
  "where is X".
- Web searches and page fetches; any "find out and report back" task.
It reports concrete results (`path:line`, the value, the snippet)
straight back. Dispatch independent lookups at once, not one after
another; execution queues serially past the concurrency cap, which is
not your problem. Do NOT read files in bulk yourself.

## Delegate to a child agent (substantial work)
- Any non-trivial change → the programming agent, with a written prompt
  and a clear output contract.
- Reviewing a change → the code-review agent(s).
- A self-contained sub-investigation that would flood your context →
  another coordinator or specialist child.

## Then integrate
- Synthesize results into one picture; resolve conflicts; drop noise.
  Decide the reduce step before you fan out.
- You hold the thread: sub-agents return facts and diffs; you decide
  what they mean and what happens next.
