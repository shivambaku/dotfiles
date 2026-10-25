#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_common.sh"

if ! command -v brew >/dev/null; then
  log 'Installing Homebrew'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

command -v brew >/dev/null || { printf 'Homebrew is not available\n' >&2; exit 1; }

# V1 and V2 install the same executable; remove the old formula before Bundle.
if brew list --formula opencode >/dev/null 2>&1; then
  log 'Removing the OpenCode V1 formula before installing V2'
  brew uninstall --formula opencode
fi

log 'Installing Homebrew packages'
brew bundle install --file="$PACKAGE_DIR/Brewfile"
