#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

log()  { echo -e "\033[1;32m$@\033[0m"; }
warn() { echo -e "\033[1;33m$@\033[0m"; }
error() { echo -e "\033[1;31m$@\033[0m"; }

log "=== Bootstrapping dotfiles ==="

# --- macOS setup (Apple Silicon assumed) ---
if [[ "$OSTYPE" == "darwin"* ]]; then
  log "→ Detected macOS (Apple Silicon assumed)"

  # Ensure Homebrew installed
  if ! command -v brew &>/dev/null; then
    warn "→ Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Ensure Homebrew path is active
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

  if ! command -v brew &>/dev/null; then
    error "❌ Homebrew installation failed or PATH not set correctly."
    exit 1
  fi

  # Ensure stow installed
  if ! command -v stow &>/dev/null; then
    log "→ Installing stow..."
    brew install stow
  else
    log "→ stow found: $(stow --version | head -n1)"
  fi

  # Link common + mac configs
  log "→ Linking common configs"
  (cd common && stow -t ~ .)

  if [[ -d mac ]]; then
    log "→ Linking macOS configs"
    (cd mac && stow -t ~ .)
  fi

# --- Linux setup ---
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  log "→ Detected Linux"

  # Ensure stow installed
  if ! command -v stow &>/dev/null; then
    warn "⚠️  'stow' not found. Please install it with your package manager (e.g., apt install stow)."
    exit 1
  fi

  # Link common + linux configs
  log "→ Linking common configs"
  (cd common && stow -t ~ .)

  if [[ -d linux ]]; then
    log "→ Linking Linux configs"
    (cd linux && stow -t ~ .)
  fi

# --- Fallback ---
else
  warn "⚠️  Unsupported OS: $OSTYPE"
  exit 1
fi

log "✅ Done!"
