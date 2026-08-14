#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_common.sh"

log 'Configuring shell'
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
fi

if [[ "${SHELL:-}" != */zsh ]]; then
  chsh -s "$(command -v zsh)"
fi
