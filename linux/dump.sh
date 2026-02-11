#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Dumping installed packages to pkglist.txt..."
paru -Qqe > "$SCRIPT_DIR/pkglist.txt"

echo "Done! $(wc -l < "$SCRIPT_DIR/pkglist.txt") packages saved."
