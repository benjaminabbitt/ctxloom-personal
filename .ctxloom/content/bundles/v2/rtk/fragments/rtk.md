---
tags:
  - tools
  - cli
  - rtk
  - tokens
content_hash: sha256:898e5ae4d60d3f0ee71c6593eca190378f9d37cec73498750105f16222dccdcb
---
# RTK (Rust Token Killer)

**Always prefix commands with `rtk`** - passes through safely if no filter exists.

**Chain commands correctly:**
```bash
rtk git add . && rtk git commit -m "msg" && rtk git push
```

## Commands

### Build (80-90%)
`rtk cargo build|check|clippy` `rtk tsc` `rtk lint` `rtk prettier --check` `rtk next build`

### Test (90-99%)
`rtk cargo test` `rtk vitest run` `rtk playwright test` `rtk test <cmd>`

### Git (59-80%)
`rtk git status|log|diff|show|add|commit|push|pull|branch|fetch|stash|worktree` - all subcommands supported

### GitHub (26-87%)
`rtk gh pr view|checks` `rtk gh run list` `rtk gh issue list` `rtk gh api`

### JS/TS (70-90%)
`rtk pnpm list|outdated|install` `rtk npm run` `rtk npx` `rtk prisma`

### Files (60-75%)
`rtk ls` `rtk read` `rtk grep` `rtk find`

### Analysis (70-90%)
`rtk err <cmd>` `rtk log` `rtk json` `rtk deps` `rtk env` `rtk summary` `rtk diff`

### Infra (85%)
`rtk docker ps|images|logs` `rtk kubectl get|logs`

### Network (65-70%)
`rtk curl` `rtk wget`

### Meta
`rtk gain [--history]` `rtk discover` `rtk proxy <cmd>`