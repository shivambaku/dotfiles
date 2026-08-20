#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

command -v stow >/dev/null || { printf 'stow is not installed\n'; exit 0; }

stow --no-folding -D -d "$SCRIPT_DIR" -t "$HOME" local
stow -D -d "$SCRIPT_DIR" -t "$HOME" stow
stow -D -d "$DOTFILES_DIR" -t "$HOME" common

printf 'Dotfile links removed. Packages and services were not changed.\n'
