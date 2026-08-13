#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

usage() {
  printf 'Usage: ./stow-only.sh [--yes]\n' >&2
  exit 2
}

command -v stow >/dev/null || { printf 'stow is not installed\n' >&2; exit 1; }

confirm=true

while (($#)); do
  case "$1" in
    --yes) confirm=false ;;
    *) usage ;;
  esac
  shift
done

case "$(uname -s)" in
  Darwin) platform=mac ;;
  Linux)  platform=linux ;;
  *)
    printf 'Unsupported OS: %s\n' "$(uname -s)" >&2
    exit 1
    ;;
esac

mkdir -p "$HOME/.config" "$HOME/.local/bin"
git -C "$DOTFILES_DIR" submodule update --init --recursive

stow --simulate --verbose -R -d "$DOTFILES_DIR" -t "$HOME" common
stow --simulate --verbose -R -d "$DOTFILES_DIR/$platform" -t "$HOME" stow

if [[ "$confirm" == true ]]; then
  read -r -p 'Apply these dotfile links? [y/N] ' reply
  [[ "$reply" == "y" || "$reply" == "Y" ]] || exit 0
fi

stow -R -d "$DOTFILES_DIR" -t "$HOME" common
stow -R -d "$DOTFILES_DIR/$platform" -t "$HOME" stow

printf 'Dotfile links applied for %s.\n' "$platform"
