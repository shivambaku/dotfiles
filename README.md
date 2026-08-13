# Dotfiles

Personal dotfiles for macOS and Arch Linux.

## Install

```bash
git clone https://github.com/shivambaku/dotfiles.git
cd dotfiles
./install.sh
```

On Arch, this installs `linux/packages/official.txt`, configures per-user Flathub
applications from `linux/packages/flatpak.txt`, applies the dotfiles, enables
NetworkManager, Bluetooth, TuneD, UFW, and Tailscale, then installs Paru after showing
its AUR build files for review. No display manager is configured.

Tailscale is enabled but must be connected manually with `sudo tailscale up`.

## Dotfiles Only

Preview and apply the shared configs plus the configs for the detected operating
system:

```bash
./stow-only.sh
```

Existing conflicting files are not overwritten; move them aside and retry after
reviewing the preview.

## Flatpak

Linux Flatpak applications are installed per-user from Flathub. Zen Browser is
tracked in `linux/packages/flatpak.txt` as `app.zen_browser.zen`.

## AUR

Install the remaining packages from `linux/packages/aur.txt` separately:

```bash
./linux/install-aur.sh
```

Paru keeps its normal interactive review and confirmation. The configured
launcher is Fuzzel; Walker is not installed.

## Updates

```bash
update-system
update-system --firmware
```

The firmware check is optional and may require a reboot.
`update-system` also updates per-user Flatpak applications.

## Package Dump

Refresh the package lists from the current Arch system:

```bash
./linux/dump.sh
```

- `official.txt`: explicitly installed official repository packages
- `aur.txt`: explicitly installed foreign packages, normally from the AUR
- `flatpak.txt`: installed per-user Flatpak applications

The regular installer never reads `aur.txt`; it only bootstraps Paru.

## Uninstall

```bash
./linux/uninstall.sh
```

This only removes Stow links. It does not remove packages or disable services.
