#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_common.sh"

multilib_enabled() {
  pacman-conf --repo-list | grep --fixed-strings --line-regexp --quiet multilib
}

if ! multilib_enabled; then
  log 'Enabling the multilib repository'
  sudo sed --in-place \
    --expression='s/^#\[multilib\]$/[multilib]/' \
    --expression='/^\[multilib\]$/ { n; s|^#Include = /etc/pacman\.d/mirrorlist$|Include = /etc/pacman.d/mirrorlist|; }' \
    /etc/pacman.conf
fi

multilib_enabled || {
  printf 'Unable to enable multilib in /etc/pacman.conf\n' >&2
  exit 1
}
