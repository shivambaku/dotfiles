#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

log()   { echo -e "\033[1;32m[+]\033[0m $*"; }
warn()  { echo -e "\033[1;33m[!]\033[0m $*"; }
error() { echo -e "\033[1;31m[-]\033[0m $*"; }

log "=== Installing dotfiles (macOS) ==="

# Ensure Homebrew installed
if ! command -v brew &>/dev/null; then
  warn "Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Ensure Homebrew path is active
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

if ! command -v brew &>/dev/null; then
  error "Homebrew installation failed or PATH not set correctly."
  exit 1
fi

log "Homebrew found: $(brew --version | head -n1)"

# Check if Brewfile exists
if [[ ! -f "$SCRIPT_DIR/Brewfile" ]]; then
  error "Brewfile not found at $SCRIPT_DIR/Brewfile"
  error "Please create it or run './mac/dump.sh' to generate one."
  exit 1
fi

# Install packages from Brewfile
log "Installing packages from Brewfile..."
brew bundle install --file="$SCRIPT_DIR/Brewfile"

# Ensure stow is installed
if ! command -v stow &>/dev/null; then
  error "stow not found after brew bundle. Something went wrong."
  exit 1
fi

log "stow found: $(stow --version | head -n1)"

# Install oh-my-zsh if not present
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  log "Installing oh-my-zsh..."
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
else
  log "oh-my-zsh already installed"
fi

log "Linking configs with stow..."
mkdir -p "$HOME/.config" "$HOME/.local/bin"
git -C "$DOTFILES_DIR" submodule update --init --recursive
stow -R -d "$DOTFILES_DIR" -t "$HOME" common
stow -R -d "$SCRIPT_DIR" -t "$HOME" stow

log "=== Installation complete ==="
log ""
log "Next steps:"
log "  1. Restart your terminal (or run 'exec zsh')"
log "  2. Open nvim to trigger plugin installation"
