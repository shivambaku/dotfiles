#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_common.sh"

log 'Linking dotfiles'
mkdir -p "$HOME/.config" "$HOME/.local/bin" "$HOME/.local/share"
git -C "$DOTFILES_DIR" submodule update --init --recursive
stow -R -d "$DOTFILES_DIR" -t "$HOME" common
stow --no-folding -R -d "$LINUX_DIR" -t "$HOME" stow
