#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LINUX_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
DOTFILES_DIR="$(cd "$LINUX_DIR/.." && pwd)"

[[ $EUID -ne 0 ]] || { printf 'Run this script as your normal user\n' >&2; exit 1; }

log() { printf '\n==> %s\n' "$*"; }
