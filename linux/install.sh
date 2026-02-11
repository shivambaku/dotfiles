#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

log()  { echo -e "\033[1;32m$*\033[0m"; }
warn() { echo -e "\033[1;33m$*\033[0m"; }
error() { echo -e "\033[1;31m$*\033[0m"; }

log "=== Installing dotfiles (Linux) ==="

# Ensure stow is installed
if ! command -v stow &>/dev/null; then
  warn "stow not found. Attempting to install..."
  
  if command -v apt &>/dev/null; then
    sudo apt update && sudo apt install -y stow
  elif command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm stow
  elif command -v dnf &>/dev/null; then
    sudo dnf install -y stow
  else
    error "Could not detect package manager. Please install stow manually."
    exit 1
  fi
fi

if ! command -v stow &>/dev/null; then
  error "stow installation failed."
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

# Initialize git submodules
log "Initializing git submodules..."
git -C "$DOTFILES_DIR" submodule update --init --recursive

# Stow common and linux configs
log "Linking configs with stow..."
stow -d "$DOTFILES_DIR" -t ~ common
stow -d "$SCRIPT_DIR" -t ~ stow

log "Done!"
log "Note: You may need to install additional packages manually (nvim, eza, lazygit, etc.)"
