#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_common.sh"

log 'Configuring password retry limits'
faillock_conf=/etc/security/faillock.conf

sudo touch "$faillock_conf"
sudo sed -i -E '/^[[:space:]]*(deny|fail_interval|unlock_time)[[:space:]]*=/d' "$faillock_conf"
sudo tee -a "$faillock_conf" >/dev/null <<'EOF'
deny = 10
fail_interval = 900
unlock_time = 60
EOF

for setting in 'deny = 10' 'fail_interval = 900' 'unlock_time = 60'; do
  grep -Fxq "$setting" "$faillock_conf" || {
    printf 'Could not configure %s in %s\n' "$setting" "$faillock_conf" >&2
    exit 1
  }
done
