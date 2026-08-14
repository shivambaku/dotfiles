#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_common.sh"

log 'Configuring services'
sudo systemctl enable docker.socket
sudo usermod -aG docker "$USER"
