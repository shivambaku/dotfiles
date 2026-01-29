---
description: Generate PR title and description from git diff
---

Analyze the current branch diff and generate a PR title and description. Keep descriptions concise and focused.

Include any issue/task references if provided: $ARGUMENTS

Current git diff:
!`git diff main...HEAD`

Recent commits:
!`git log --oneline main..HEAD`

## Generate

### Title (Simple Action-Based)

- Fix [issue description]
- Add [new feature]
- Update [what was changed]
- Remove [what was removed]
- Refactor [area/component]

### Description Format

Summary paragraph describing the improvement or outcome.

### Changes

- Key technical modifications.

### Context

- Background explanation or reason for the change.
- Include issue/task reference if provided in arguments.

### Testing

- How changes were verified.

## Examples

### Feature Example

```
Add dark mode toggle

Provide dark mode option for better user accessibility.

### Changes
- New toggle component in settings.
- Theme switching logic.

### Context
- Users requested accessibility feature for reduced eye strain.
- [Related Task: LINK_PLACEHOLDER]

### Testing
- Manual testing across all pages.
```

### Fix Example

```
Fix API returning stale user data

Show the most current user data in the application.

### Changes
- Order by `LastUpdatedDate` descending.

### Context
- Previous query returned first record instead of latest, causing outdated information.
- [Related Issue: LINK_PLACEHOLDER]

### Testing
- Verified users see most current data correctly.
```

## Usage Examples

- `/pr-help` - Basic PR generation
- `/pr-help "Fixes #123"` - Include GitHub issue
- `/pr-help "Task ABC-456"` - Include task reference
