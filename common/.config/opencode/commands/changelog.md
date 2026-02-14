---
description: Generate changelog entries from code changes
---

Analyze code changes and generate changelog entries.

Arguments: $ARGUMENTS (default: main...HEAD)
Examples: "main...dev", "v1.5.0...HEAD", "3d3c0f5"

Code diff:
!`git diff $ARGUMENTS`

File changes:
!`git diff --stat $ARGUMENTS`

Guidelines:
- Focus on WHAT changed from user/developer perspective, not HOW
- One concise line per significant change
- User-facing language - what will users/developers notice?

Format (bullet points grouped by type):
- Added: new features (from feat commits)
- Changed: modifications to existing functionality (from refactor, perf, style commits)
- Deprecated: soon-to-be removed features
- Removed: deleted features or files
- Fixed: bug fixes (from fix commits)
- Security: security-related changes

Omit empty types.
