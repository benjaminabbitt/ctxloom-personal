---
distilled_by: claude-3-opus
---
# rtk

**Always prefix commands with `rtk`** - passes through safely if no filter exists.

**Chain:** `rtk git add . && rtk git commit -m "msg" && rtk git push`

## Commands

| Category | Commands | Savings |
|----------|----------|---------|
| Build | `cargo build\|check\|clippy`, `tsc`, `lint`, `prettier --check`, `next build` | 80-90% |
| Test | `cargo test`, `vitest run`, `playwright test`, `test <cmd>` | 90-99% |
| Git | `status\|log\|diff\|show\|add\|commit\|push\|pull\|branch\|fetch\|stash\|worktree` | 59-80% |
| GitHub | `gh pr view\|checks`, `gh run list`, `gh issue list`, `gh api` | 26-87% |
| JS/TS | `pnpm list\|outdated\|install`, `npm run`, `npx`, `prisma` | 70-90% |
| Files | `ls`, `read`, `grep`, `find` | 60-75% |
| Analysis | `err <cmd>`, `log`, `json`, `deps`, `env`, `summary`, `diff` | 70-90% |
| Infra | `docker ps\|images\|logs`, `kubectl get\|logs` | 85% |
| Network | `curl`, `wget` | 65-70% |

**Meta:** `rtk gain [--history]`, `rtk discover`, `rtk proxy <cmd>`