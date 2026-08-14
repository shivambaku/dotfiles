#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_common.sh"

log 'Configuring console'
sudo touch /etc/vconsole.conf
sudo sed -i '/^[[:space:]]*FONT=/d' /etc/vconsole.conf
printf 'FONT=ter-v32n\n' | sudo tee -a /etc/vconsole.conf >/dev/null
sudo systemctl restart systemd-vconsole-setup.service
