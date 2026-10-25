#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_common.sh"

log 'Configuring desktop preferences'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
