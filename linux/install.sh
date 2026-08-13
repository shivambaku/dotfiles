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
mapfile -t aur_manifest < "$SCRIPT_DIR/packages/aur.txt"
mapfile -t flatpaks < "$SCRIPT_DIR/packages/flatpak.txt"

aur_packages=()
for package in "${aur_manifest[@]}"; do
  [[ -z "$package" || "$package" == "paru" ]] && continue
  aur_packages+=("$package")
done

printf 'Official packages:\n'
printf '  %s\n' "${packages[@]}"
printf 'AUR packages:\n'
printf '  paru\n'
if ((${#aur_packages[@]})); then
  printf '  %s\n' "${aur_packages[@]}"
fi
printf 'Flatpak applications (per-user):\n'
printf '  %s\n' "${flatpaks[@]}"
printf 'Services: NetworkManager, systemd-resolved, Bluetooth, Docker, TuneD, UFW\n'
printf 'Configs: common, linux/stow\n'
printf 'AUR helper: paru\n'
printf 'Boot menu: no timeout when using systemd-boot\n'

read -r -p 'Continue? [y/N] ' reply
[[ "$reply" == "y" || "$reply" == "Y" ]] || exit 0

sudo pacman -Syu --needed -- "${packages[@]}"

rustup default nightly
rustup component add rust-src rustfmt clippy rust-analyzer

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

sudo systemctl enable --now NetworkManager.service systemd-resolved.service bluetooth.service docker.service tuned.service
sudo usermod -aG docker "$USER"
sudo ln -sfn /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
sudo ufw --force enable
sudo systemctl enable --now ufw.service

if sudo bootctl --quiet is-installed; then
  sudo bootctl set-timeout 0
fi

bootstrapped_paru=false
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
    makepkg -sir
  )
  bootstrapped_paru=true
fi

command -v paru >/dev/null || die "Paru was not installed"

# makepkg can install a detached debug-symbol package for the bootstrap build.
if [[ "$bootstrapped_paru" == true ]] && pacman -Q paru-debug >/dev/null 2>&1; then
  sudo pacman -Rns --noconfirm paru-debug
fi

if ((${#aur_packages[@]})); then
  paru -S --needed -- "${aur_packages[@]}"
fi

sudo voxtype setup onnx --enable
voxtype setup --download --model parakeet-tdt-0.6b-v3-int8
systemctl --user enable voxtype

eval "$(fnm env --shell bash)"
fnm install --lts --use
fnm default "$(fnm current)"

log "Installation complete"
log "Start Hyprland with: start-hyprland"
log "After starting Hyprland, enroll a fingerprint with: fprintd-enroll"
log "Check firmware with: update-system --firmware"
