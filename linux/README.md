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
| `Biei`                          | `biei`                  | `home`, `wifi`, `dns`, `bluetooth`, `--focused`, `--help`                            | System overview, Wi-Fi, DNS, and Bluetooth controls.                                             |
| `SB - System Report`            | `report-system`          | `crash [latest\|PID] [--include-command-line]`, `--no-pager`, `--help`                | Summarizes recent problems and produces focused, shareable crash reports.                         |
| `SB - System Update`            | `update-system`          | None                                                                                 | Prunes the package cache, then updates Arch, AUR, and user Flatpak packages.                     |
| `SB - System Update + Firmware` | `update-system`          | `--firmware`                                                                         | Runs the system update and installs available device firmware updates.                           |

### Crash Reports

Open a focused report for the latest crash or a PID shown in the system report:

```sh
report-system crash latest
report-system crash 135971
```

Copy a plain-text report to the clipboard for review before sending it to AI:

```sh
report-system crash latest | wl-copy
```

Process command lines can contain secrets or private identifiers, so they are omitted by default. Add one only after reviewing it:

```sh
report-system crash 135971 --include-command-line
```

Focused reports never include the raw core dump, which can contain passwords, tokens, and private document contents.
