# Arch Linux Setup

This setup expects a base Arch installation created with `archinstall`. The
dotfile installer installs applications and user configuration; it does not
replace the system network configuration selected during Archinstall.

## Archinstall Choices

Use these choices in the guided installer:

- **Network configuration:** `Use standalone iwd`
- **Audio:** `PipeWire`
- **Bootloader:** `systemd-boot`
- **Profile:** `Minimal`
- **User account:** create a user with sudo access

The standalone iwd option configures Wi-Fi, DHCP, DNS, wired DHCP, and the
required `iwd`, `systemd-networkd`, and `systemd-resolved` services. Connect to
Wi-Fi in the installer environment before starting Archinstall.

No display manager is required. Hyprland is started manually after installing
the dotfiles.

## Install Dotfiles

After booting the installed system:

```bash
git clone https://github.com/shivambaku/dotfiles.git
cd dotfiles
./install.sh
```

The installer adds the remaining packages, applies the Stow configuration,
enables desktop-related services, and bootstraps Paru. It does not modify the
network stack selected during Archinstall.
