#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

log() { echo -e "\033[1;32m$@\033[0m"; }

log "=== Bootstrapping dotfiles ==="

log "→ Linking common configs"
(cd common && stow -t ~ .)

if [[ "$OSTYPE" == "darwin"* ]]; then
  # log "→ Linking macOS configs"
  # (cd mac && stow -t ~ .)
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # log "→ Linking Linux configs"
  # (cd linux && stow -t ~ .)
else
  log "⚠️  Unsupported OS: $OSTYPE"
fi

log "✅ Done!"
