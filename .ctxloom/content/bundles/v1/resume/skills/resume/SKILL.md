---
name: resume
description: Bring back context from an earlier session — recover what /clear just wiped from THIS still-live session, pick up the session immediately before this one, or load a specific named prior session. Use when the user says "resume", "recover", "continue from last time", "what was I working on", right after a /clear, or when ctxloom's own start-session banner named a previous session for this project.
---

# resume

ctxloom's `run` startup (Decision 11 of the CLI-primary reorg) never asks you
to pick a session to resume — every `ctxloom run` opens a brand-new harp and
prints a read-only summary before the engine even starts, including (when one
exists) a line like:

```
previous session: quiet-loyal-otter — bring it back in-session with the "resume" skill
```

That line is what this skill is for: resuming prior context is now something
YOU (the model) do, from inside the session that's already running, not a
startup-time flag or picker. This skill replaces the old `/recover` slash
command and the old `run --session`/`--tasks-from` flags — both retired.

## Open by asking: which context, and from where?

There are three distinct situations this skill covers. They use different
tools; don't guess which one applies — the trigger tells you:

1. **A `/clear` just happened IN THIS SESSION.** The context window was
   wiped, but the session itself is still alive — its transcript kept
   growing right through the clear. Go to **"Recover after /clear"** below.
2. **The user wants to continue from "last time" / "where I left off"**, and
   hasn't named a specific session. This is the session immediately BEFORE
   the one you're in now, for this project. Go to **"Pick up the previous
   session"** below.
3. **The user (or the start-session banner) names a SPECIFIC session** — a
   harp name (e.g. `quiet-loyal-otter`) or a backend session ID. Go to
   **"Load a named session"** below.

These are independent — do only the one the trigger calls for. If none of
the three obviously apply (e.g. the user just wants a status update on the
CURRENT session), this skill isn't the right tool; don't force it.

## Recover after /clear

Use the `recover_session` MCP tool. `/clear` empties the context window but
does **not** end the session — ctxloom resolves the current (still-live)
session at read time and re-distills its still-growing transcript, so
whatever was said before the clear is still recoverable.

1. Call `recover_session` with no arguments (it defaults to the most recent
   session for this working directory — which is THIS session). Only pass
   `session_id` if you have a specific reason to target a different session
   explicitly.
2. If content comes back, go to **"Review and hand back"** below.
3. If nothing comes back ("No recoverable context found"), say so plainly —
   don't invent a summary. A brand-new session (nothing happened before the
   clear) or a very short one can legitimately have nothing worth
   distilling.

## Pick up the previous session

Use the `get_previous_session` MCP tool. It resolves the most recent session
BEFORE the currently active one, for this project, via the session registry
— the same resolution ctxloom's own start-session banner uses, so what it
finds matches what the banner named. It is cross-agent aware (the previous
session may have run under a different engine than this one) and falls back
to the second-most-recent transcript if the registry entry is incomplete.

1. Call `get_previous_session` with no required arguments.
2. If it returns nothing, there is no earlier session for this project (this
   is the first one) — say so.
3. Otherwise go to **"Review and hand back"** below.

Don't confuse this with the `/clear` case: `get_previous_session` looks
BACKWARD to a session that already ended; `recover_session` looks at the
CURRENT session's own pre-clear content. If the user just typed `/clear`,
that's `recover_session`, not this.

## Load a named session

Use the `load_session` MCP tool when a specific session is named — by the
user, or because the start-session banner (or `ctxloom session list`) named
one you're now acting on.

1. Call `load_session` with `harp_name` (the human-readable name, e.g.
   `quiet-loyal-otter` — prefer this when you have it) or `session_id` (a
   backend UUID). If both are somehow known, `harp_name` wins.
2. If you don't know the exact harp name, list candidates first rather than
   guessing — `ctxloom session list` (or the `list_sessions` MCP tool) shows
   recent harp-named sessions for this project; confirm with the user before
   loading if there's any ambiguity.
3. Go to **"Review and hand back"** below.

## Review and hand back

Whichever branch you took, once content comes back:

1. Read the restored context and summarize it for the user:
   - What was being worked on
   - Key decisions made
   - Progress achieved
   - Any planned next steps
2. Ask: "I've recovered context from \<where it came from\>. Ready to
   continue?" — name the actual source (this session pre-clear / the
   previous session / the named session), don't be vague.
3. Don't silently merge recovered context into your own plan without
   surfacing it first — the point of this skill is that the user sees what
   came back before you act on it.

## Verify — the exit criterion

Don't treat "the tool call returned something" as done. The user should have
seen a real summary (not a raw dump) and confirmed they want to continue
before you act on the recovered context. If a tool call returns nothing,
report that plainly rather than fabricating content to fill the gap.
