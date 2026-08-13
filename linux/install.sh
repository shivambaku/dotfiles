#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

log() { printf '\033[1;32m[+]\033[0m %s\n' "$*"; }
die() { printf '\033[1;31m[-]\033[0m %s\n' "$*" >&2; exit 1; }

[[ $# -eq 0 ]] || die "Usage: ./install.sh"
[[ -r /etc/os-release ]] || die "This installer requires Arch Linux"
# shellcheck disable=SC1091
source /etc/os-release
[[ "${ID:-}" == "arch" ]] || die "This installer requires Arch Linux"
[[ $EUID -ne 0 ]] || die "Run this installer as your normal user"
command -v pacman >/dev/null || die "pacman is required"
command -v sudo >/dev/null || die "sudo is required"

mapfile -t packages < "$SCRIPT_DIR/packages/official.txt"
mapfile -t flatpaks < "$SCRIPT_DIR/packages/flatpak.txt"
printf 'Official packages:\n'
printf '  %s\n' "${packages[@]}"
printf 'Flatpak applications (per-user):\n'
printf '  %s\n' "${flatpaks[@]}"
printf 'Services: Bluetooth, TuneD, UFW, Tailscale\n'
printf 'Configs: common, linux/stow\n'
printf 'AUR helper: paru\n'
printf 'Boot menu: no timeout when using systemd-boot\n'

read -r -p 'Continue? [y/N] ' reply
[[ "$reply" == "y" || "$reply" == "Y" ]] || exit 0

sudo pacman -Syu --needed -- "${packages[@]}"

flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
if ((${#flatpaks[@]})); then
  flatpak install --user --noninteractive --or-update flathub "${flatpaks[@]}"
fi

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
fi

"$DOTFILES_DIR/stow-only.sh" --yes

if [[ "${SHELL:-}" != */zsh ]]; then
  chsh -s "$(command -v zsh)"
fi

sudo systemctl enable --now bluetooth.service tuned.service tailscaled.service
sudo ufw --force enable
sudo systemctl enable --now ufw.service

if sudo bootctl --quiet is-installed; then
  sudo bootctl set-timeout 0
fi

if ! command -v paru >/dev/null; then
  (
    build_dir="$(mktemp -d)"
    trap 'rm -rf "$build_dir"' EXIT

    git clone https://aur.archlinux.org/paru.git "$build_dir/paru"
    printf '\nReviewing Paru AUR files:\n'
    bat --paging=always --style=plain "$build_dir/paru/PKGBUILD" "$build_dir/paru/.SRCINFO"

    read -r -p 'Build and install Paru? [y/N] ' reply
    [[ "$reply" == "y" || "$reply" == "Y" ]] || exit 1

    cd "$build_dir/paru"
    makepkg -si
  )
fi

command -v paru >/dev/null || die "Paru was not installed"

log "Installation complete"
log "Start Hyprland with: start-hyprland"
log "Connect Tailscale with: sudo tailscale up"
log "Check firmware with: update-system --firmware"
log "Install remaining AUR packages with: ./linux/install-aur.sh"
