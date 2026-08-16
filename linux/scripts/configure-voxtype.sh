#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_common.sh"

log 'Setting up Voxtype'
sudo voxtype setup onnx --enable
voxtype setup --download --model parakeet-tdt-0.6b-v3-int8
