#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

usage() {
  printf 'Usage: ./linux/stow.sh [--common|--linux] [--yes]\n' >&2
  exit 2
}

command -v stow >/dev/null || { printf 'stow is not installed\n' >&2; exit 1; }

mkdir -p "$HOME/.config" "$HOME/.local/bin"

scopes=(common linux)
confirm=true

while (($#)); do
  case "$1" in
    --common) scopes=(common) ;;
    --linux)  scopes=(linux) ;;
    --yes)    confirm=false ;;
    *)        usage ;;
  esac
  shift
done

for scope in "${scopes[@]}"; do
  if [[ "$scope" == "common" ]]; then
    git -C "$DOTFILES_DIR" submodule update --init --recursive
    break
  fi
done

for scope in "${scopes[@]}"; do
  if [[ "$scope" == "common" ]]; then
    stow --simulate --verbose -R -d "$DOTFILES_DIR" -t "$HOME" common
  else
    stow --simulate --verbose -R -d "$SCRIPT_DIR" -t "$HOME" stow
  fi
done

if [[ "$confirm" == true ]]; then
  read -r -p 'Apply these dotfile links? [y/N] ' reply
  [[ "$reply" == "y" || "$reply" == "Y" ]] || exit 0
fi

for scope in "${scopes[@]}"; do
  if [[ "$scope" == "common" ]]; then
    stow -R -d "$DOTFILES_DIR" -t "$HOME" common
  else
    stow -R -d "$SCRIPT_DIR" -t "$HOME" stow
  fi
done

printf 'Dotfile links applied.\n'
