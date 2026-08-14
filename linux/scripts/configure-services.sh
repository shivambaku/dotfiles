#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_common.sh"

log 'Configuring services'
sudo systemctl enable bluetooth.service docker.socket tuned.service ufw.service
sudo usermod -aG docker "$USER"
sudo ufw --force enable
