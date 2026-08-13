# Arch Linux Setup

Target: Intel Framework laptop.

## 1. Install Arch

Run `archinstall` with:

- Disk: default layout with LUKS encryption
- Bootloader: `systemd-boot`
- Profile: `Minimal`
- Audio: `PipeWire`
- Network: `NetworkManager`
- User: sudo access

## 2. Install Dotfiles

Connect to the network with `nmtui` if required, then run:

```bash
sudo pacman -Syu --needed git
git clone https://github.com/shivambaku/dotfiles.git
cd dotfiles
./install.sh
reboot
```

The installer may prompt for package and AUR confirmation. Rerun it if an
installation step is interrupted.

## 3. Enroll Fingerprint

Log in on TTY1. Hyprland starts automatically.

```bash
fprintd-enroll
```

Additional finger:

```bash
fprintd-enroll -f left-index-finger
```

## 4. Install 1Password

Follow the [1Password Arch Linux installation instructions](https://support.1password.com/install-linux/#arch-linux).
