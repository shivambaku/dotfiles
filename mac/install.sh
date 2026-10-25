#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

scripts=(
  install-packages
  configure-shell
  configure-dotfiles
)

for script in "${scripts[@]}"; do
  "$SCRIPT_DIR/setup/$script.sh"
done

printf 'Installation complete\n'
printf "Restart your terminal (or run 'exec zsh').\n"
printf 'Open nvim to trigger plugin installation.\n'
