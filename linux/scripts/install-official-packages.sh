#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_common.sh"

mapfile -t packages < "$LINUX_DIR/packages/official.txt"

log 'Installing official packages'
sudo pacman -Syu --needed -- "${packages[@]}"
