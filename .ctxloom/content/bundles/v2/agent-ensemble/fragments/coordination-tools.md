---
tags:
  - coordinator
  - tooling
notes: |
  Why: the field reference for these tools is generated from the
  schema, but a schema cannot carry the working model, and the
  failures this defends against are all model errors: expecting
  agent_run to hand back the result (it returns at enqueue),
  misjudging how dispatched children are scheduled, treating
  agent_stop as ending the session rather than the run, or moving
  artifact content by value when it travels by reference. The
  fragment preloads the correct model so the first use of each tool
  is right, instead of each error being discovered live against a
  running child.
---
# Coordination tools

The working model for the seven delegation tools — not the field
reference (see the generated schema docs).

- `agent_run(role, input.prompt, budget?, notify_on?)` — async
  spawn. Returns at enqueue with `child_agent_id` (the child's
  harp, its durable address) and `child_run_id`, not the result.
  Children run SERIALLY — a spawn past the concurrency cap
  queues. Dispatch many at once freely; do not expect concurrent
  wall-clock execution.
- `agent_recv(wait, up to 600s)` — your inbox. Results,
  questions, and reports arrive here, at-least-once, deduped on
  `message_id`.
- `agent_send(to_agent_id, text, structured?, in_reply_to?,
  artifact_ids?)` — a durable, queued follow-up to a child by
  harp; sending to an ended session resumes it. A child may only
  address `to_role: "parent"`; peer-to-peer routes through you.
- `roster(role?, include_terminal?, ...)` — each child's state
  and latest report summary, and the harps/run_ids the other
  tools need.
- `agent_stop(run_id, grace?, reason?)` — kills the RUN, not the
  session. A later agent_send resumes the child under a fresh
  run_id.
- `agent_fetch_artifact(agent_id, artifact_id, dest_path)` —
  sha256-verified fetch of a child-published artifact into your
  session workdir. Children publish via agent_report's
  publish_paths/artifact_ids; artifacts travel by reference,
  never by value.
- `agent_report` scopes, from your side: PROGRESS, STEP,
  CHECKPOINT (resumable synthesis, supersedes prior checkpoints),
  FINAL — the child's completion contract (see prompt-authoring).