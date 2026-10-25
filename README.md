# Dotfiles

## Install Arch

Boot in UEFI mode and run `archinstall` with:

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

## Install dotfiles

Log in as your normal user and connect with `nmtui` if needed:

```bash
git clone https://github.com/shivambaku/dotfiles.git
cd dotfiles
./install.sh
reboot
```

After rebooting, log in on TTY1 to start Hyprland automatically.
The installer includes 1Password through AUR; open it and sign in.

## Workspaces

| Workspace | Role               |
| --------- | ------------------ |
| `1`       | Terminal / Work    |
| `2`       | Browser            |
| `3`       | Communication      |
| `4`       | Project Management |
| `5`       | Lounge             |

## Updates

Run `update-system` to prune package caches and update Arch, AUR, and user
Flatpak apps. Add `--firmware` to include firmware updates.

---

The last version with macOS support is preserved in the `last-macos-support` Git tag.
