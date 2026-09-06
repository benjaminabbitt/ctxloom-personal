---
tags:
  - tooling
  - memory
---
# Searching past sessions (claude-mem)

Searchable memory ACROSS past sessions. claude-mem captures session
activity through lifecycle hooks and serves it back over MCP.
Capture is passive — you never call anything to store memory, and
there is no documented "remember this" tool.

Reach for it when you need "what did we decide about X", "have we
hit this error before", "what was I working on last week" — the
questions ctxloom's own session tools cannot answer.

## Retrieval

Three MCP tools, served under `mcp-search`:

- `search(query, limit, offset, type, obs_type, project,
  dateStart, dateEnd, orderBy)` — full-text + semantic search over
  stored observations. Start here.
- `timeline(anchor, query, depth_before, depth_after, project)` —
  what happened around a point, once `search` gives you an anchor.
- `get_observations(ids, orderBy, limit, project)` — fetch specific
  observations once you know which ones you want.

Search, then widen with `timeline`, then pull detail with
`get_observations`. Don't open with a broad `search` at a high
`limit` — that re-fills the context window you are protecting.
Scope with `project` and `dateStart`/`dateEnd` when you can; an
unscoped query across every project you've touched returns noise.

## Know which tool answers which question

ctxloom's `load_session`, `get_previous_session` and
`recover_session` retrieve a KNOWN session — by harp name, by id,
or by recency. They do NOT search by content. claude-mem answers
the other question: WHICH session was it? Use claude-mem to find
it, ctxloom to load it.

The ctxloom `search_content` / `search_library` tools search the
content LIBRARY (fragments, skills, profiles, installable
bundles) — not sessions. Don't send session questions there.

## What it costs

Compression is a real LLM call per observation (Haiku by default,
configurable). Session content therefore LEAVES the machine to
whichever provider is configured — treat that as a privacy
boundary, not a local-only store. The vector index (Chroma) is
local.

## Anti-patterns

- Asking claude-mem about the CURRENT session. Scroll up, or use
  ctxloom's session tools.
- Broad unscoped searches that dump dozens of observations.
- Treating a memory hit as current. An observation records what was
  true when written; if it names a file, flag, or command, verify
  the thing still exists before acting on it.