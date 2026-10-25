# Dotfiles Guide

## Layout

- `stow/`: application, shell, and desktop configuration.
- `local/`: individually linked files, everyday commands, and desktop entries.
- `setup/`: rerunnable setup steps; `packages/` holds software manifests.
- `install.sh`: ordered setup; `setup/configure-dotfiles.sh`: links only.
- `unlink.sh`: removes managed links, leaving packages and system settings.

## Working Here

- Edit repository sources, not generated or runtime-managed copies. Keep secrets,
  caches, and application state outside Git.
- Use normal folded Stow links for `stow`.
  Only `local` uses `--no-folding`. Target `~/.config` directly for
  application directories; preserve unrelated files when deploying or unlinking.
- Record dependencies in `setup/packages/`: official/AUR/npm/Flatpak manifests.
  Setup scripts use strict Bash mode and source `_common.sh`.
  Run as the normal user and elevate only commands requiring root.
- Prefer native, static configuration and small focused scripts. Add migration
  handling only for concrete existing installations that need it.

## Configuration Conventions

- Theme sources live in `stow/.config/dotfiles/theme/`; read its README.
  Keep native files and relative discovery links; check embedded colors and
  browser synchronization helpers when changing the palette.
- Hyprland modules live in `stow/.config/hypr/`; Noctalia owns the shell,
  bar, notifications, and lock screen. Inspect live window identities for rules.
- Commands and launcher entries live under `local/.local/`.
  Preserve CLI output contracts; send diagnostics to stderr and respect `NO_COLOR`.
- Inspect effective application state when it differs from tracked configuration.
  A compositor reload does not test login-only startup behavior.

## Validation

- Run focused format checks (for example `bash -n`, `zsh -n`, `luac -p`), and
  ShellCheck when available. Preserve executable modes and repository symlinks.
- Dry-run Stow before deployment changes.
- Exercise affected application behavior where practical. Report source checks
  separately from live tests; ask before logout, reboot, or disruptive system tests.
- Run `git diff --check` before finishing.
