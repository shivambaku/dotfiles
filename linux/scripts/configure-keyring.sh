#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_common.sh"

log 'Configuring GNOME Keyring'

login_pam=/etc/pam.d/login
if ! grep -Eq '^[[:space:]]*auth[[:space:]]+optional[[:space:]]+pam_gnome_keyring\.so([[:space:]]|$)' "$login_pam"; then
  sudo sed -i \
    '/^[[:space:]]*auth[[:space:]]\+include[[:space:]]\+system-local-login[[:space:]]*$/a auth       optional     pam_gnome_keyring.so' \
    "$login_pam"
fi
grep -Eq '^[[:space:]]*auth[[:space:]]+optional[[:space:]]+pam_gnome_keyring\.so([[:space:]]|$)' "$login_pam" || {
  printf 'Could not add the GNOME Keyring auth hook to %s\n' "$login_pam" >&2
  exit 1
}

if ! grep -Eq '^[[:space:]]*session[[:space:]]+optional[[:space:]]+pam_gnome_keyring\.so[[:space:]]+auto_start([[:space:]]|$)' "$login_pam"; then
  sudo sed -i \
    '/^[[:space:]]*session[[:space:]]\+include[[:space:]]\+system-local-login[[:space:]]*$/a session    optional     pam_gnome_keyring.so auto_start' \
    "$login_pam"
fi
grep -Eq '^[[:space:]]*session[[:space:]]+optional[[:space:]]+pam_gnome_keyring\.so[[:space:]]+auto_start([[:space:]]|$)' "$login_pam" || {
  printf 'Could not add the GNOME Keyring session hook to %s\n' "$login_pam" >&2
  exit 1
}

passwd_pam=/etc/pam.d/passwd
if ! grep -Eq '^[[:space:]]*password[[:space:]]+optional[[:space:]]+pam_gnome_keyring\.so([[:space:]]|$)' "$passwd_pam"; then
  printf 'password\toptional\tpam_gnome_keyring.so\n' | sudo tee -a "$passwd_pam" >/dev/null
fi
grep -Eq '^[[:space:]]*password[[:space:]]+optional[[:space:]]+pam_gnome_keyring\.so([[:space:]]|$)' "$passwd_pam" || {
  printf 'Could not add the GNOME Keyring password hook to %s\n' "$passwd_pam" >&2
  exit 1
}
