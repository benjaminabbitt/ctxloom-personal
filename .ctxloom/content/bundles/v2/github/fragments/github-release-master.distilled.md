---
distilled_by: claude-code
---
# GitHub Release Pipeline (Master)

Every master push auto-releases: build-test (skipped on `[skip ci]`) → integration → mutation gate (fail if score < 60%) → bump-release (patch bump, `release/vX.Y.Z` branch, push `v*` tag) → tag triggers separate release.yml.

Key patterns: `[skip ci]` on version commits prevents infinite loops; `release/vX.Y.Z` branch naming; `v*` tag triggers release.yml; mutation threshold quality gate starts at 60%; dogfood the project's own version tool.