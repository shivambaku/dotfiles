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

Log in as the normal user. Connect to the network with `nmtui` if required,
then run:

```bash
git clone https://github.com/shivambaku/dotfiles.git
cd dotfiles
./install.sh
reboot
```

The installer may prompt for package and AUR confirmation. Rerun it if an
installation step is interrupted.

Individual setup steps can be rerun from `linux/scripts/`.

After rebooting, log in on TTY1 to start Hyprland automatically. The reboot
also applies the larger console font, Zsh login shell, and Docker group
membership.

## 3. Enroll Fingerprint

```bash
fprintd-enroll
```

Additional finger:

```bash
fprintd-enroll -f left-index-finger
```

Verify fingerprint:

```bash
fprintd-verify
```

## 4. Install 1Password

Follow the [1Password Arch Linux installation instructions](https://support.1password.com/install-linux/#arch-linux).
