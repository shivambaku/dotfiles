#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_common.sh"

log 'Configuring boot'
cmdline="$(< /etc/kernel/cmdline)"
for parameter in quiet systemd.show_status=auto udev.log_level=3; do
  [[ " $cmdline " == *" $parameter "* ]] || cmdline+=" $parameter"
done

temporary="$(mktemp)"
trap 'rm -f "$temporary"' EXIT
printf '%s\n' "$cmdline" > "$temporary"
sudo install -m 0644 "$temporary" /etc/kernel/cmdline

for preset in /etc/mkinitcpio.d/*.preset; do
  [[ -e "$preset" ]] || continue
  sudo sed -i \
    -e '\|^[[:space:]]*default_options="--splash /usr/share/systemd/bootctl/splash-arch.bmp"[[:space:]]*$|d' \
    -e 's|--splash /usr/share/systemd/bootctl/splash-arch.bmp||g' \
    "$preset"
done

sudo mkinitcpio -P
sudo bootctl set-timeout 0
