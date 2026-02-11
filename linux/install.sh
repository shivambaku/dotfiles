#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

log()   { echo -e "\033[1;32m[+]\033[0m $*"; }
warn()  { echo -e "\033[1;33m[!]\033[0m $*"; }
error() { echo -e "\033[1;31m[-]\033[0m $*"; }

log "=== Installing dotfiles (Arch Linux) ==="

# Check if running on Arch Linux
if ! command -v pacman &>/dev/null; then
    error "This script requires Arch Linux (pacman not found)"
    exit 1
fi

# Check if sudo is installed and configured
if ! command -v sudo &>/dev/null; then
    error "sudo is not installed."
    error ""
    error "To install sudo on Arch Linux:"
    error "  1. Switch to root: su -"
    error "  2. Install sudo: pacman -S sudo"
    error "  3. Add your user to wheel group: usermod -aG wheel <your-username>"
    error "  4. Configure sudoers: EDITOR=vim visudo"
    error "     (Uncomment line: %wheel ALL=(ALL:ALL) ALL)"
    error "  5. Exit root and re-run this script"
    exit 1
fi

if ! sudo -v 2>/dev/null; then
    error "Current user does not have sudo privileges."
    error ""
    error "To grant sudo access:"
    error "  1. Switch to root: su -"
    error "  2. Add your user to wheel group: usermod -aG wheel $USER"
    error "  3. Configure sudoers: EDITOR=vim visudo"
    error "     (Uncomment line: %wheel ALL=(ALL:ALL) ALL)"
    error "  4. Log out and back in, then re-run this script"
    exit 1
fi

# Bootstrap paru if not present
if ! command -v paru &>/dev/null; then
    log "Installing paru (AUR helper)..."
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    (cd /tmp/paru && makepkg -si --noconfirm)
    rm -rf /tmp/paru
fi

if ! command -v paru &>/dev/null; then
    error "paru installation failed"
    exit 1
fi

log "paru found: $(paru --version | head -n1)"

# Check if pkglist.txt exists
if [[ ! -f "$SCRIPT_DIR/pkglist.txt" ]]; then
    error "pkglist.txt not found at $SCRIPT_DIR/pkglist.txt"
    error "Please create it or run './linux/dump.sh' on an existing Arch system."
    exit 1
fi

# Install packages from pkglist.txt
log "Installing packages from pkglist.txt..."
paru -S --needed --noconfirm --ask 4 - < "$SCRIPT_DIR/pkglist.txt"

# Verify stow is installed
if ! command -v stow &>/dev/null; then
    error "stow not found after package installation. Check pkglist.txt"
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
    log "Backing up existing .zshrc to .zshrc.backup..."
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi

# Initialize git submodules
log "Initializing git submodules..."
git -C "$DOTFILES_DIR" submodule update --init --recursive

# Stow common and linux configs
log "Linking configs with stow..."
stow -d "$DOTFILES_DIR" -t ~ common
stow -d "$SCRIPT_DIR" -t ~ stow

# Set zsh as default shell
if [[ "$SHELL" != *"zsh"* ]]; then
    log "Setting zsh as default shell..."
    chsh -s "$(which zsh)"
fi

log "=== Installation complete ==="
log ""
log "Next steps:"
log "  1. Log out and back in (or run 'exec zsh')"
log "  2. Open nvim to trigger plugin installation"
