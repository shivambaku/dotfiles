# Arch Linux Setup

## 1. Install Arch

Run `archinstall` with:

- Boot the installer in UEFI mode
- Disk: default layout with LUKS encryption
- Bootloader: `systemd-boot`
- Unified kernel images: enabled
- Profile: `Minimal`
- Bluetooth: enabled
- Audio: `PipeWire`
- Power management: `tuned`
- Firewall: `ufw`
- Network: `NetworkManager`
- User: create a normal user with sudo access
- Additional packages: `git`

## 2. Install Dotfiles

As the normal user, connect with `nmtui` if needed, then run:

```sh
git clone https://github.com/shivambaku/dotfiles.git
./dotfiles/install.sh
reboot
```

After rebooting, log in on TTY1.

## 3. Enroll Fingerprint

```sh
fprintd-enroll
```

Additional finger:

```sh
fprintd-enroll -f left-index-finger
```

Verify fingerprint:

```sh
fprintd-verify
```

## System Maintenance

Open the local system report from the application launcher or run:

```sh
report-system
```

The report combines warnings and errors from the current and previous boots,
Noctalia warnings, crashes, failed services, pending `.pacnew`/`.pacsave` files,
and kernel update status. It is regenerated at
`${XDG_RUNTIME_DIR}/system-report/index.html` and removed at logout or reboot.

To generate the report without opening a browser:

```sh
report-system --no-open
```
