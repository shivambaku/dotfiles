#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PACKAGE_DIR="$SCRIPT_DIR/packages"
temporary="$(mktemp -d)"
trap 'rm -rf "$temporary"' EXIT

command -v pacman >/dev/null || { printf 'pacman is required\n' >&2; exit 1; }

pacman -Qq | sort > "$temporary/all.txt"
pacman -Qqen | sort > "$temporary/official-explicit.txt"
pacman -Qqem | sort > "$temporary/aur-explicit.txt"
if command -v flatpak >/dev/null; then
  {
    flatpak list --user --app --columns=application
    flatpak list --system --app --columns=application
  } | sort -u > "$temporary/flatpak-installed.txt"
else
  : > "$temporary/flatpak-installed.txt"
fi

report_diff() {
  local heading=$1
  local left=$2
  local right=$3
  local result

  result="$(comm -23 "$left" "$right")"
  printf '%s\n' "$heading"
  if [[ -n "$result" ]]; then
    printf '%s\n' "$result"
  else
    printf '  none\n'
  fi
}

report_diff 'Missing official packages:' "$PACKAGE_DIR/official.txt" "$temporary/all.txt"
report_diff 'Untracked explicit official packages:' "$temporary/official-explicit.txt" "$PACKAGE_DIR/official.txt"
report_diff 'Missing AUR packages:' "$PACKAGE_DIR/aur.txt" "$temporary/aur-explicit.txt"
report_diff 'Untracked explicit foreign packages:' "$temporary/aur-explicit.txt" "$PACKAGE_DIR/aur.txt"
report_diff 'Missing Flatpak applications:' "$PACKAGE_DIR/flatpak.txt" "$temporary/flatpak-installed.txt"
