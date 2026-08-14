#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

read -r -p 'Install system packages and dotfiles? [y/N] ' reply
[[ "$reply" == "y" || "$reply" == "Y" ]] || exit 0

scripts=(
  install-official-packages
  configure-development
  install-aur-packages
  install-flatpaks
  configure-shell
  link-dotfiles
  setup-voxtype
  configure-services
  configure-boot
)

for script in "${scripts[@]}"; do
  "$SCRIPT_DIR/scripts/$script.sh"
done

printf 'Installation complete\n'
printf 'Reboot, then enroll a fingerprint with: fprintd-enroll\n'
printf 'Check firmware with: update-system --firmware\n'
