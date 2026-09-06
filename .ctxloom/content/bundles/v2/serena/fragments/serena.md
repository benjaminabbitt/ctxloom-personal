---
tags:
  - code-intelligence
  - tools
---
# serena: address code by symbol, not by file and line

Serena puts a language server behind MCP tools that name SYMBOLS.
Prefer them over Read/Grep/Edit whenever the question or the change
is about a symbol.

## Reach for these first

- `get_symbols_overview` — what is in this file? The first call on
  an unfamiliar one.
- `find_symbol` — locate a definition by name path (`Type/method`).
  `include_body: true` reads ONE symbol instead of a whole file.
- `find_referencing_symbols` — every caller of a symbol. That is the
  blast-radius question, and grep answers it with false positives
  and misses aliased or qualified uses.
- `replace_symbol_body`, `insert_before_symbol`,
  `insert_after_symbol`, `rename_symbol`, `safe_delete_symbol` —
  edit by identity. `safe_delete_symbol` refuses while references
  remain, which a string edit cannot check.

## Why this is stated here

Serena's own registration injects an INDIRECTION — "call
`initial_instructions` before starting a coding task". An agent that
skips that call never learns the tools exist, and skipping it is the
normal outcome rather than the exception. This says it inline so the
guidance does not depend on a tool call nobody makes.

## Where they do not help

Non-code files (YAML, Markdown, JSON), whole-file reads you actually
need, and languages with no server configured. Read and Edit stay
correct there, as does a line-oriented edit INSIDE a symbol body
once you have located it.

## Delegating

Name the symbol tools in sub-agent briefs. An implementer told to
"read before you write" reaches for Read unless told otherwise.

## NOT for an agent working in a WORKTREE

The server resolves its project ONCE, at start-up, from the cwd of
the session that launched it. It is a long-lived process, and an
in-process sub-agent inherits the parent's connection rather than
getting its own. So every symbol call an agent makes is answered
against the COORDINATOR's checkout, whatever directory that agent
believes it is working in.

For a worktree-isolated agent this is wrong in both directions, and
silently:

- EDITS land in the coordinator's checkout. The agent's own worktree
  is untouched, so the change is both missing where it belongs and
  present where nobody asked for it.
- READS answer about the wrong tree. A symbol that exists only in
  the worktree is reported as not found; one deleted there is
  reported as present.

The failure has no error. A delete can report OK while writing
nothing the agent can see, so an agent that trusts the result
reports success having changed nothing.

**A brief that assigns a worktree must therefore tell the agent to
use Read/Edit and plain search, not serena.** Symbol tools are for
an agent working in the same checkout the server was started in.

## Containers

An agent bound to `runtime: container` cannot see a host-installed
serena. Either install serena in the image, or keep serena on
host-runtime agents.
