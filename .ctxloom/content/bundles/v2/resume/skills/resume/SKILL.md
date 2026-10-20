---
name: resume
description: Bring back context from an earlier session — recover what /clear just wiped from THIS still-live session, pick up the session immediately before this one, or read a specific named prior session — from the transcript ctxloom recorded for it. Use when the user says "resume", "recover", "continue from last time", "what was I working on", or right after a /clear.
---

# resume

ctxloom's `run` startup never asks you to pick a session to resume — every
`ctxloom run` opens a brand-new harp. ctxloom does not compact or distill
sessions, and has no MCP tool that loads one: the engine compacts its own
context. What ctxloom keeps of every session is its recorded transcript,
`~/.ctxloom/sessions/<harp>/transcripts/transcript.jsonl` — one JSON line per
event, the turns being the lines whose `kind` is `entry` (`entry.type` is
`user`, `assistant`, `tool_use`, `tool_result`, …). It can be large: read
its tail, or filter it to the `user` and `assistant` turns, rather than
loading it whole.

There are two ways back into an earlier session:

- **At launch, by the human:** `ctxloom run --session <harp>` starts a new
  session with the named session's full recorded transcript folded into its
  assembled context. Suggest it when the user wants to carry on a whole
  earlier session rather than pull part of it into this one.
- **In-session, by YOU (the model):** find the session and read what you
  need from its transcript. That is what this skill is for.

## Open by asking: which context, and from where?

There are three distinct situations this skill covers. They find the
session differently; don't guess which one applies — the trigger tells you:

1. **A `/clear` just happened IN THIS SESSION.** The context window was
   wiped, but the session itself is still alive. Go to **"Recover after
   /clear"** below.
2. **The user wants to continue from "last time" / "where I left off"**, and
   hasn't named a specific session. This is the session immediately BEFORE
   the one you're in now, for this project. Go to **"Pick up the previous
   session"** below.
3. **The user names a SPECIFIC session** — a harp name (e.g.
   `quiet-loyal-otter`). Go to **"Load a named session"** below.

These are independent — do only the one the trigger calls for. If none of
the three obviously apply (e.g. the user just wants a status update on the
CURRENT session), this skill isn't the right tool; don't force it.

## Recover after /clear

`/clear` empties the context window but does **not** end the session. This
session's harp name is in the ctxloom MCP server's instructions ("Your
session is named …"); read the turns before the clear from its transcript.

1. Read this session's transcript for the turns from before the clear.
2. If content comes back, go to **"Review and hand back"** below.
3. If there is nothing before the clear (or no transcript yet), say so
   plainly — don't invent a summary.

## Pick up the previous session

Run `ctxloom session list`. It lists this project's recorded sessions with
their title (the first thing each one's user asked), state and start/end
times; the previous session is the most recent one that ENDED before this
one started.

1. If there is none, this is the first session for this project — say so.
2. Otherwise read its transcript and go to **"Review and hand back"** below.

Don't confuse this with the `/clear` case: here you look BACKWARD to a
session that already ended; after a `/clear` you read the CURRENT session's
own pre-clear content.

## Load a named session

When a specific session is named:

1. `ctxloom session show <harp>` confirms it exists and shows its title,
   state, engine and times.
2. If you don't know the exact harp name, find candidates rather than
   guessing — `ctxloom session list`, or `ctxloom session search <word>...`
   (it matches the harp name, title and times, NOT what was said in the
   session); confirm with the user before reading if there's any ambiguity.
3. Read its transcript and go to **"Review and hand back"** below.

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

Don't treat "the read returned something" as done. The user should have
seen a real summary (not a raw dump) and confirmed they want to continue
before you act on the recovered context. If the transcript has nothing to
offer, report that plainly rather than fabricating content to fill the gap.
