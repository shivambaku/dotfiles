#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_common.sh"

mapfile -t manifest < "$LINUX_DIR/packages/aur.txt"
packages=()
for package in "${manifest[@]}"; do
  [[ -z "$package" || "$package" == "paru" ]] || packages+=("$package")
done

log 'Installing AUR packages'
if ! command -v paru >/dev/null; then
  build_dir="$(mktemp -d)"
  trap 'rm -rf "$build_dir"' EXIT

  git clone https://aur.archlinux.org/paru.git "$build_dir/paru"
  bat --paging=always --style=plain "$build_dir/paru/PKGBUILD" "$build_dir/paru/.SRCINFO"

  read -r -p 'Build and install Paru? [y/N] ' reply
  [[ "$reply" == "y" || "$reply" == "Y" ]] || exit 1

  (cd "$build_dir/paru" && makepkg -sir)

  if pacman -Q paru-debug >/dev/null 2>&1; then
    sudo pacman -Rns --noconfirm paru-debug
  fi
fi

if ((${#packages[@]})); then
  paru -S --needed -- "${packages[@]}"
fi
