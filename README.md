# Dotfiles

Dotfiles for macOS and Arch Linux.

## Install

Arch Linux: follow [`linux/README.md`](linux/README.md).

macOS:

```bash
git clone https://github.com/shivambaku/dotfiles.git
cd dotfiles
./install.sh
```

## Commands

```bash
./stow-only.sh             # Apply dotfiles only
./linux/dump.sh            # Audit Arch package manifests
./linux/uninstall.sh       # Remove Linux Stow links
update-system              # Update packages
update-system --firmware   # Update packages and firmware
```

Package manifests:

- `linux/packages/official.txt`
- `linux/packages/aur.txt`
- `linux/packages/flatpak.txt`
