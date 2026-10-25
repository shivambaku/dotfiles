#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

command -v stow >/dev/null || { printf 'stow is not installed\n'; exit 0; }

stow --no-folding -D -d "$SCRIPT_DIR" -t "$HOME" local
stow -D --ignore='^\.config$' -d "$SCRIPT_DIR" -t "$HOME" stow
if [[ -d "$HOME/.config" ]]; then
  stow -D -d "$SCRIPT_DIR/stow" -t "$HOME/.config" .config
fi

printf 'Dotfile links removed. Packages and services were not changed.\n'
