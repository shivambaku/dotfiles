#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

log()  { echo -e "\033[1;32m$*\033[0m"; }
error() { echo -e "\033[1;31m$*\033[0m"; }

# Detect OS
case "$(uname -s)" in
  Darwin)
    log "Detected macOS"
    exec "$SCRIPT_DIR/mac/install.sh"
    ;;
  Linux)
    log "Detected Linux"
    exec "$SCRIPT_DIR/linux/install.sh"
    ;;
  *)
    error "Unsupported OS: $(uname -s)"
    exit 1
    ;;
esac
