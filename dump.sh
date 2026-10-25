#!/usr/bin/env bash
set -euo pipefail
export LC_ALL=C

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PACKAGE_DIR="$SCRIPT_DIR/setup/packages"
temporary="$(mktemp -d)"
trap 'rm -rf "$temporary"' EXIT

command -v pacman >/dev/null || { printf 'pacman is required\n' >&2; exit 1; }

pacman -Qq | sort > "$temporary/all.txt"
pacman -Qqen | sort > "$temporary/official-explicit.txt"
pacman -Qqem | sort > "$temporary/aur-explicit.txt"
if command -v flatpak >/dev/null; then
  {
    flatpak list --user --app --columns=application
    flatpak list --system --app --columns=application
  } | sort -u > "$temporary/flatpak-installed.txt"
else
  : > "$temporary/flatpak-installed.txt"
fi

report_diff() {
  local heading=$1
  local manifest=$2
  local installed=$3
  local result
  local -a missing=() untracked=()

  result="$(comm -23 "$manifest" "$installed")"
  if [[ -n "$result" ]]; then
    mapfile -t missing <<< "$result"
  fi

  if (($# == 4)); then
    result="$(comm -23 "$4" "$manifest")"
    if [[ -n "$result" ]]; then
      mapfile -t untracked <<< "$result"
    fi
    if ((${#missing[@]} == 0 && ${#untracked[@]} == 0)); then
      printf '%s — no differences\n' "$heading"
    else
      printf '%s — %d missing, %d untracked\n' "$heading" "${#missing[@]}" "${#untracked[@]}"
    fi
  else
    printf '%s — %d missing\n' "$heading" "${#missing[@]}"
  fi

  if ((${#missing[@]})); then
    printf '  %s (missing)\n' "${missing[@]}"
  fi
  if ((${#untracked[@]})); then
    printf '  %s\n' "${untracked[@]}"
  fi
}

report_diff 'Official packages' "$PACKAGE_DIR/official.txt" "$temporary/all.txt" "$temporary/official-explicit.txt"
printf '\n'
report_diff 'AUR packages' "$PACKAGE_DIR/aur.txt" "$temporary/aur-explicit.txt" "$temporary/aur-explicit.txt"
report_diff 'Flatpak apps' "$PACKAGE_DIR/flatpak.txt" "$temporary/flatpak-installed.txt"
