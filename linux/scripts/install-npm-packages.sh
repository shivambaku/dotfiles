#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_common.sh"

mapfile -t manifest < "$LINUX_DIR/packages/npm.txt"
packages=()
for package in "${manifest[@]}"; do
  [[ -z "$package" ]] || packages+=("$package")
done

if ((${#packages[@]})); then
  log 'Installing npm packages'
  eval "$(fnm env --shell bash)"
  npm install --global -- "${packages[@]}"
fi
