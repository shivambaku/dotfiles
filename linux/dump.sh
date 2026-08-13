#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PACKAGE_DIR="$SCRIPT_DIR/packages"
temporary="$(mktemp -d)"
trap 'rm -rf "$temporary"' EXIT

command -v pacman >/dev/null || { printf 'pacman is required\n' >&2; exit 1; }

pacman -Qqen | sort > "$temporary/official.txt"
pacman -Qqem | sort > "$temporary/aur.txt"
if command -v flatpak >/dev/null; then
  flatpak list --user --app --columns=application | sort > "$temporary/flatpak.txt"
else
  : > "$temporary/flatpak.txt"
fi

mv "$temporary/official.txt" "$PACKAGE_DIR/official.txt"
mv "$temporary/aur.txt" "$PACKAGE_DIR/aur.txt"
mv "$temporary/flatpak.txt" "$PACKAGE_DIR/flatpak.txt"

printf 'Updated linux/packages/official.txt, linux/packages/aur.txt, and linux/packages/flatpak.txt\n'
