#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

read -r -p 'Install system packages and dotfiles? [y/N] ' reply
[[ "$reply" == "y" || "$reply" == "Y" ]] || exit 0

scripts=(
  install-official-packages
  configure-console
  link-dotfiles
  configure-desktop
  configure-services
  configure-boot
  configure-shell
  configure-development
  install-aur-packages
  install-flatpaks
  setup-voxtype
)

for script in "${scripts[@]}"; do
  "$SCRIPT_DIR/scripts/$script.sh"
done

printf 'Installation complete\n'
printf 'Reboot, then enroll a fingerprint with: fprintd-enroll\n'
printf 'Check firmware with: update-system --firmware\n'
