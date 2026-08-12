#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

command -v paru >/dev/null || {
  printf 'Paru is not installed. Run ./install.sh first.\n' >&2
  exit 1
}

packages=()
while IFS= read -r package || [[ -n "$package" ]]; do
  [[ -z "$package" || "$package" == "paru" ]] && continue
  packages+=("$package")
done < "$SCRIPT_DIR/packages/aur.txt"

if ((${#packages[@]} == 0)); then
  printf 'No AUR packages to install.\n'
  exit 0
fi

printf 'AUR packages:\n'
printf '  %s\n' "${packages[@]}"
paru -S --needed -- "${packages[@]}"
