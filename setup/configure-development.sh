#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_common.sh"

log 'Configuring development toolchains'
rustup default nightly
rustup component add rust-src rustfmt clippy rust-analyzer

eval "$(fnm env --shell bash)"
fnm install --lts --use
fnm default "$(fnm current)"
