#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_common.sh"

log 'Linking dotfiles'
command -v stow >/dev/null || { printf 'stow is required; run linux/setup/install-official-packages.sh first\n' >&2; exit 1; }
mkdir -p "$HOME/.config" "$HOME/.local/bin" "$HOME/.local/share"
git -C "$DOTFILES_DIR" submodule update --init --recursive
# Target ~/.config directly so Stow folds app folders, not ~/.config itself.
stow -R --ignore='^\.config$' -d "$DOTFILES_DIR" -t "$HOME" common
stow -R -d "$DOTFILES_DIR/common" -t "$HOME/.config" .config
stow -R -d "$LINUX_DIR" -t "$HOME" stow
stow --no-folding -R -d "$LINUX_DIR" -t "$HOME" local

log 'Refreshing desktop application database'
update-desktop-database "$HOME/.local/share/applications"
