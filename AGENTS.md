# Dotfiles Guide

## Repository Layout

- `common/` contains configuration shared by Linux and macOS.
- `linux/stow/` contains Linux configuration deployed with normal folded GNU Stow links.
- `linux/local/` contains individually linked Linux files and is the only package deployed with `stow --no-folding`.
- `mac/stow/` contains macOS-specific configuration.
- `linux/packages/` and `mac/Brewfile` are the persistent software manifests.
- `linux/scripts/` contains the ordered, rerunnable installation steps invoked by `linux/install.sh`.

## Task Guides

Load the matching global skill before making changes in these areas:

- `dotfiles-theme` for the centralized theme bundle, palette changes, and new theme consumers.
- `dotfiles-desktop` for Hyprland, Noctalia, workspaces, bindings, launchers, and desktop behavior.
- `dotfiles-provisioning` for Stow, packages, installers, services, and cross-platform file placement.
- `dotfiles-terminal-tools` for custom commands, terminal UI, reports, and their desktop entries.

Use more than one skill when a change crosses boundaries, such as adding a themed terminal utility and its package dependency.

## Invariants

- Edit the repository-owned source, not a deployed path or generated runtime copy.
- Never change `common` or `linux/stow` to `--no-folding`; doing so replaces folded directory links with large trees of per-file links.
- Keep shared configuration in `common/` and platform behavior in its platform directory.
- Record persistent software in the appropriate manifest rather than installing it only on the current machine.
- Do not track credentials, application state, caches, generated files, or machine-specific secrets.
- Prefer the existing static, inspectable architecture over generators, migration layers, or new state unless the task requires them.
- Do not add backward-compatibility handling without a concrete persisted or already-deployed state that needs migration.

## Validation

- Run focused syntax or schema validation for every changed format.
- Use Stow dry-runs before changing deployment structure or introducing links.
- Validate both Linux and macOS paths when shared configuration changes.
- Distinguish source validation from live reload testing and report when a live application could not be exercised.
- Run `git diff --check` before finishing.
