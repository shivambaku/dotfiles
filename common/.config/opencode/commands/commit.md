---
description: Commit staged changes and push
---

Create commit from staged changes and push to remote.

Staged changes:
!`git diff --cached`

Format:
- Message: `type(scope): description`
- Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore
- Scope: optional area of codebase (e.g., api, ui, cli)
- Description: imperative mood (add, fix, not added, fixed)
- Breaking changes: add ! after type (e.g., feat!: or fix!:)

After committing:
- Push to remote with rebase if needed
- On conflicts, notify user - do not resolve
