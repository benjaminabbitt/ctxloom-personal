---
distilled_by: claude-code
---
# Working Context Directory

Keep a gitignored `_ctx/` directory for ephemeral LLM working files: plans/ (impl plans, decision drafts), checklists/, status/ (multi-session task state, review progress), research/, scratch/, prompts/, summaries/ (module overviews). Lifecycle: create status/plan at session start; update with completed items, decisions, blockers during; periodically delete stale files (>2 weeks) and archive keepers to real docs/ADRs. Start sessions by reading `_ctx/status/`; end by updating status with next steps.