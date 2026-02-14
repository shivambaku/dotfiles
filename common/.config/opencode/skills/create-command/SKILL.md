---
name: create-command
description: Create or modify OpenCode commands
---

## Location

`.opencode/commands/<name>.md`

## Format

```markdown
---
description: Short description
---

What the command does (1 sentence).

Arguments: $ARGUMENTS (if needed)

Context:
!`git diff --cached`

Instructions:
- Point 1
- Point 2
```

## Guidelines

- Keep it simple and concise
- Use bullet points for instructions
- Include git commands for context when useful
- No bold formatting in bullet points
