---
description: Generate PR title and description
---

Generate PR title and description from current branch changes.

Arguments: $ARGUMENTS (optional issue/task reference)

Git diff:
!`git diff main...HEAD`

Recent commits:
!`git log --oneline main...HEAD`

Format:

- Title: `type(scope): description`
  - Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore
  - Scope: optional package/area (e.g., app, desktop, api)
  - Description: imperative mood, can be slightly longer than commit messages
  - Breaking changes: add ! after type (e.g., feat!: or fix!:)
- Summary: why this change matters (1 paragraph)
- Changes: key technical modifications
- Context: background or reason for change
- Testing: how changes were verified

Focus on WHY from user perspective, not just WHAT changed.
