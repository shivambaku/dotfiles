# Dotfiles

Personal dotfiles for macOS and Arch Linux.

## Quick Start

```bash
git clone https://github.com/shivambaku/dotfiles.git
cd dotfiles
./install.sh  # Auto-detects OS and installs
```

## Package Management

**Export current packages:**

- macOS: `./mac/dump.sh` → `mac/Brewfile`
- Arch: `./linux/dump.sh` → `linux/pkglist.txt`

Packages are automatically installed during `./install.sh`

## Notes

- **macOS:** Homebrew is auto-installed if not present
- **Arch Linux:** Requires `sudo` configured (script will guide you if missing)
