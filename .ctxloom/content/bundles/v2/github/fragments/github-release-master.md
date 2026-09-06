---
tags:
  - github
  - ci-cd
  - release
content_hash: sha256:e96250ed9be63d70db3bd3be85974e91c86ebd13384acfc2222a5ce86c4c5c34
---
# GitHub Release Pipeline (Master Branch)

Every push to master auto-releases: build/test, mutation gate, patch version bump, release branch + tag, full release workflow.

## Pipeline Flow

```
push to master
     │
     ▼
┌─────────────┐
│ build-test  │ ── Skip if [skip ci] in commit message
└─────────────┘
     │
     ▼
┌─────────────┐
│ integration │
└─────────────┘
     │
     ▼
┌─────────────┐
│  mutation   │ ── Fail if score < threshold (60%)
└─────────────┘
     │
     ▼
┌─────────────┐
│ bump-release│ ── Bump patch, create release/vX.Y.Z branch, push tag
└─────────────┘
     │
     ▼
release.yml triggered by v* tag
```

## Key Patterns

| Pattern | Purpose |
|---------|---------|
| `[skip ci]` | Prevent infinite loop on version commits |
| `release/vX.Y.Z` | Release branch naming convention |
| `v*` tag | Triggers separate release.yml workflow |
| Mutation threshold | Quality gate (start at 60%) |
| Dogfooding | Use project's own tools for versioning |