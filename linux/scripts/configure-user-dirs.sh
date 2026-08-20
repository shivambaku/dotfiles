#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_common.sh"

log 'Configuring user directories'
mkdir -p "$HOME/Downloads" "$HOME/Documents/Projects"
xdg-user-dirs-update --set DOWNLOAD "$HOME/Downloads"
xdg-user-dirs-update --set DOCUMENTS "$HOME/Documents"
