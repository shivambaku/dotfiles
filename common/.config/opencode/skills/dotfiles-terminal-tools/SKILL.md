---
name: dotfiles-terminal-tools
description: Use ONLY when work concerns terminal tools maintained by this dotfiles-managed system, including custom commands, interactive pickers, reports, shared presentation, SB launcher entries, pager behavior, or output contracts. Explains reusable ANSI roles, stdout and stderr separation, desktop integration, dependency ownership, and safe validation.
---

# Dotfiles Terminal Tools

Keep custom commands understandable as ordinary shell programs while providing consistent terminal and launcher behavior.

## Source Map

- Maintained user commands live under `linux/local/.local/bin/`.
- Shared command support lives under `linux/local/.local/share/dotfiles/`.
- Graphical launcher entries live under `linux/local/.local/share/applications/`.
- Persistent command dependencies belong in the appropriate Linux package manifest.

Inspect neighboring commands and desktop entries before creating a new convention.

## Command Contract

Each command should have a clear non-interactive core even when its default interface is interactive. Prefer explicit status or output modes when another script may consume the command.

Use strict shell mode and fail with a concise command-qualified error. Validate required commands before beginning mutations. Keep usage text synchronized with accepted arguments and return nonzero for invalid input or failed operations.

Separate presentation from system operations. A display refactor must not silently change profile selection, networking, package updates, rollback, or other mutation behavior.

## Shared Presentation

Source the existing terminal UI helper instead of duplicating colors and formatting. It uses semantic ANSI roles that inherit the active terminal theme; do not embed the current palette's RGB values in tools.

Use the established primitives for titles, sections, fields, choices, information, success, warnings, errors, and prompts. Extend the helper only when multiple tools benefit from the same primitive.

Presentation must:

- Activate only on the relevant terminal stream.
- Respect `NO_COLOR`.
- Remain readable without color.
- Avoid decorative output in machine-readable modes.
- Avoid untrusted terminal control sequences from logs, device labels, filenames, or command output.

## Streams And Interaction

- Write data intended for pipelines to stdout.
- Write prompts, warnings, and errors to stderr.
- Determine prompt color from stderr's terminal state, not stdout's.
- Never wait for input behind a prompt that disappeared because stdout was redirected.
- Keep non-interactive output free of ANSI escapes unless explicitly requested.
- Preserve stable short/status output when presentation changes.

Ask before exercising a mutating path that changes network, audio, package, service, firmware, or other live system state. Prefer status and fixture paths for routine validation.

## Reports And Pagers

Generate reports into a private temporary directory when no persistent artifact is required. Use a trap to remove temporary data on success, error, or pager exit.

Use Bat's built-in pager for maintained interactive reports when it provides the needed behavior without another dependency. Provide a plain-output option so users can redirect and retain a report explicitly.

Keep collection, rendering, and paging conceptually separate. Sanitize collected text before terminal rendering, handle missing optional fields without shifting columns, and ensure headings do not promise a time range or completeness the collector does not provide.

## Desktop Integration

Follow the existing `SB -` launcher naming, icon, metadata, and terminal-launch conventions. A launcher should include an accurate generic name, concise comment, useful search keywords, and an `Exec` command that matches terminal behavior.

Use `TryExec` when appropriate. Set `Terminal` according to whether the desktop entry starts its own terminal. Do not add Noctalia-specific registration when an ordinary XDG desktop entry is discovered automatically.

When adding a new file beneath `linux/local`, account for its intentional no-folding deployment and refresh the user desktop database after installation.

## Dependencies

Prefer tools already maintained by the system when they simplify the implementation. Do not add a UI framework for styling that the shared shell helper can provide. If a new runtime dependency is justified, record it in the correct package manifest and fail clearly when it is unavailable.

## Verification

- Run `bash -n` and `shellcheck` when available.
- Confirm new commands retain executable mode and run through their deployed command path.
- Validate desktop entries with `desktop-file-validate` when available.
- Exercise help, invalid arguments, status, redirected output, `NO_COLOR`, and missing-dependency behavior as applicable.
- Confirm redirected output contains no ANSI escape sequences.
- Test interactive rendering in a pseudo-terminal when practical.
- Confirm temporary artifacts are removed after normal and interrupted exits.
- Test data fixtures and malformed optional fields for parsers and reports.
- Avoid mutation tests unless they are safe and explicitly approved.
- Use a Stow dry-run for new deployed paths and refresh the desktop database after live deployment.
- Run `git diff --check`.
