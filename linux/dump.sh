#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PACKAGE_DIR="$SCRIPT_DIR/packages"
temporary="$(mktemp -d)"
trap 'rm -rf "$temporary"' EXIT

command -v pacman >/dev/null || { printf 'pacman is required\n' >&2; exit 1; }

pacman -Qqen | sort > "$temporary/official.txt"
pacman -Qqem | sort > "$temporary/aur.txt"

mv "$temporary/official.txt" "$PACKAGE_DIR/official.txt"
mv "$temporary/aur.txt" "$PACKAGE_DIR/aur.txt"

printf 'Updated linux/packages/official.txt and linux/packages/aur.txt\n'
