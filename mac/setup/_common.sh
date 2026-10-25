#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_DIR="$SCRIPT_DIR/packages"
MAC_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
DOTFILES_DIR="$(cd "$MAC_DIR/.." && pwd)"

[[ $EUID -ne 0 ]] || { printf 'Run this script as your normal user\n' >&2; exit 1; }

# Include Homebrew tools when running setup before the first shell login.
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/local/sbin:$PATH"

log() { printf '\n==> %s\n' "$*"; }
