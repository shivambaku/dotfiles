---
name: create-skill
description: Create or modify OpenCode skills
---

## Location

`.opencode/skills/<name>/SKILL.md`

## Format

```markdown
---
name: skill-name
description: What this skill does (required, 1-1024 chars)
---

## Use this when

- Condition 1
- Condition 2

## [Content sections]

Guidance, patterns, examples as needed. Keep it practical and concise.
```

## Naming

- Lowercase alphanumeric with single hyphens (e.g., `git-release`, `bun-file-io`)
- Must match directory name

## Guidelines

- Keep skills focused on one domain
- Be specific enough for agent selection
- Include practical examples when useful
- Use bullet points for clarity
