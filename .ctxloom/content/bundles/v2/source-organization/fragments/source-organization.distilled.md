---
distilled_by: claude-haiku-4-5-20251001
---
# Repository and Worktree Layout

**Primary checkout** — leaf must be project name:
```
~/workspace/<project>
```

**Worktrees** — flat structure outside every repo:
```
~/workspace/worktrees/<project>--<branch-slug>    # feature/auth → feature-auth
```

Leaf directory carries both project + branch; visible in tooling. Slugify `/` → `-` for directory names only.

**Common Mistakes:**
- Primary checkout named `main` — must name project
- Worktree inside or beside repo — place in root only
- Reusing removed worktree directory — run `git worktree prune` first