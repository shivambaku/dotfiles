# Arch Linux Setup

## Installation

### Install Arch

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

### Install Dotfiles

As the normal user, connect with `nmtui` if needed, then run:

```sh
git clone https://github.com/shivambaku/dotfiles.git
./dotfiles/install.sh
reboot
```

After rebooting, log in on TTY1.

### Enroll Fingerprints

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

## Workspaces

| Workspace | Role               |
| --------- | ------------------ |
| `1`       | Terminal / Work    |
| `2`       | Browser            |
| `3`       | Communication      |
| `4`       | Project Management |
| `5`       | Lounge             |

## Utilities

| Launcher                        | Command                  | Arguments                                                                            | Summary                                                                                          |
| ------------------------------- | ------------------------ | ------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------ |
| `Biei`                          | `biei`                  | `home`, `wifi`, `dns`, `bluetooth`, `reports`, `--focused`, `--help`                 | System overview, diagnostics, Wi-Fi, DNS, and Bluetooth controls.                                 |
| `SB - System Update`            | `update-system`          | None                                                                                 | Prunes the package cache, then updates Arch, AUR, and user Flatpak packages.                     |
| `SB - System Update + Firmware` | `update-system`          | `--firmware`                                                                         | Runs the system update and installs available device firmware updates.                           |

Open `biei reports` for failed services, grouped events, config updates, and crash details.
Use `/` to search, Space for the time range or copying the report, Enter for details, and `y` to copy an item or its open details.
