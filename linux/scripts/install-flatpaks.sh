#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_common.sh"

mapfile -t packages < "$LINUX_DIR/packages/flatpak.txt"

log 'Installing Flatpak applications'
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
if ((${#packages[@]})); then
  flatpak install --user --noninteractive --or-update flathub "${packages[@]}"
fi
