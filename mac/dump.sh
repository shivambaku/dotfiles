#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Dumping installed packages to Brewfile..."
brew bundle dump --file="$SCRIPT_DIR/Brewfile" --force --no-npm

echo "Done! Brewfile updated."
