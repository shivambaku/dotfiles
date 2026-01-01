#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

log()  { echo -e "\033[1;32m$*\033[0m"; }
warn() { echo -e "\033[1;33m$*\033[0m"; }
error() { echo -e "\033[1;31m$*\033[0m"; }

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
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  log "oh-my-zsh already installed"
fi

# Backup existing .zshrc if present (so stow can create symlink)
if [[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
  log "Backing up existing .zshrc..."
  mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi

# Stow common and mac configs
log "Linking configs with stow..."
stow -d "$DOTFILES_DIR/stow" -t ~ common mac

log "Done!"
