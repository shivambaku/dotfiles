#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

log()  { echo -e "\033[1;32m$*\033[0m"; }
warn() { echo -e "\033[1;33m$*\033[0m"; }

log "=== Uninstalling dotfiles (macOS) ==="

if ! command -v stow &>/dev/null; then
  warn "stow not found. Nothing to uninstall."
  exit 0
fi

log "Unlinking configs with stow..."
stow -D -d "$DOTFILES_DIR/stow" -t ~ common mac

log "Done! Symlinks removed."
log "Note: Homebrew packages were not removed. Run 'brew bundle cleanup --file=$SCRIPT_DIR/Brewfile' to remove them."
