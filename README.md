# Dotfiles

Dotfiles for macOS and Arch Linux.

## Layout

- `common/`: shared application configuration.
- `linux/stow/` and `mac/stow/`: platform-specific configuration.
- `linux/local/`: individually linked configuration, commands, and launchers.
- `linux/setup/` and `mac/setup/`: installation steps and `packages/` manifests.

Theme files live in [`common/.config/dotfiles/theme`](common/.config/dotfiles/theme/README.md).

## Install

```bash
git clone https://github.com/shivambaku/dotfiles.git
cd dotfiles
./install.sh
```

The root installer selects the platform. Each platform installer runs its setup
steps in order. See [Linux setup](linux/README.md) for the Arch prerequisites.
On macOS, setup installs Homebrew if needed, applies the Brewfile, installs
Oh My Zsh, and links configuration.

## Link configuration only

With Git and GNU Stow installed, run the appropriate command without installing
packages or configuring system services:

```bash
./linux/setup/configure-dotfiles.sh
# or, on macOS:
./mac/setup/configure-dotfiles.sh
```

Both initialize the Zsh plugin submodules. Linux also refreshes the desktop-entry
database using `update-desktop-database` from `desktop-file-utils`.
Shared and platform configuration use normal folded Stow links; only
`linux/local/` uses `--no-folding` to coexist with application-created files.

## Unlink

Run `./linux/unlink.sh` or `./mac/unlink.sh` to remove managed links. This leaves
repository files, installed packages, services, and system settings in place;
it does not restore previous configuration.

## Package manifests

- Linux: `linux/setup/packages/{official,aur,npm,flatpak}.txt`.
- macOS: `mac/setup/packages/Brewfile`.

`./linux/dump.sh` reports package differences. `./mac/dump.sh` overwrites the
Brewfile with the installed Homebrew selection; review its diff before committing.
