---
name: dotfiles-provisioning
description: Use ONLY when work concerns provisioning this dotfiles-managed system, including adding or removing software, changing GNU Stow deployment, editing Linux or macOS installers, configuring services or boot behavior, choosing file ownership, or preparing a machine. Explains manifests, installer ordering, link safety, idempotence, and cross-platform validation.
---

# Dotfiles Provisioning

Keep a fresh installation reproducible without destabilizing an already deployed home directory.

## Ownership Model

- `common/` owns files that should be identical on Linux and macOS.
- `linux/stow/` and `mac/stow/` own platform-specific configuration using normal folded Stow deployment.
- `linux/local/` owns selected files beneath user data directories and is intentionally deployed with `--no-folding` so it can coexist with runtime-created files.
- `linux/scripts/` owns ordered Arch setup operations.
- `linux/packages/` and `mac/Brewfile` own persistent software selection.

Choose ownership based on behavior, not merely on where a file was first created. Shared application configuration belongs in `common`; operating-system integration belongs in its platform directory.

## Stow Invariants

The established deployment is:

- Normal folded Stow for `common`.
- Normal folded Stow for each platform's `stow` package.
- `--no-folding` only for `linux/local`.

Never apply `--no-folding` broadly to solve one file conflict. It converts managed directory links into trees of individual links and makes rollback significantly more complicated.

Before editing a deployed path, resolve whether it is a repository link, a generated file, or unmanaged user state. Edit the repository source directly. Before adding or moving links, use an isolated target or Stow dry-run and inspect conflicts without deleting user files.

## Software Manifests

On Arch Linux, place persistent software in the manifest matching its source:

- Repository packages in `linux/packages/official.txt`.
- AUR packages in `linux/packages/aur.txt`.
- Global Node tools in `linux/packages/npm.txt`.
- Flatpak applications in `linux/packages/flatpak.txt`.

On macOS, place Homebrew formulae, casks, taps, and supported application records in `mac/Brewfile`.

Check whether a package already exists in another source before adding it. Prefer official repositories over the AUR when they provide the intended package. Review AUR metadata and upstream ownership rather than treating all AUR packages as equivalent.

Installing something on the live machine is not enough; update its manifest when it is meant to survive reinstall. Conversely, do not add a temporary diagnostic dependency to a manifest unless it becomes part of the maintained system.

## Installer Changes

Linux installation is orchestrated by the ordered script list in `linux/install.sh`. Each leaf script should:

- Use strict shell mode.
- Source `_common.sh`.
- Run as the normal user and elevate only the narrow commands requiring root.
- Be safe to rerun or explicitly guard one-time state.
- Fail clearly when a required operation cannot be verified.
- Have a focused `configure-*` or `install-*` responsibility.

Order scripts by dependency. Package installation must precede configuration that invokes those packages. Dotfile deployment must precede commands that require deployed helpers. Keep final reboot or login requirements explicit.

macOS installation should preserve the Brew bundle, common Stow, platform Stow, and shell/bootstrap ordering already established by `mac/install.sh`.

## Services, Boot, And Privilege

Distinguish system services from user services and sockets. Enable only the narrow unit required by the feature. Do not start or restart unrelated services during validation.

Treat bootloader, kernel, PAM, keyring, firewall, networking, and disk changes as high risk. Inspect current state and upstream configuration before editing. Prefer idempotent checks around system files, and verify the resulting line or setting after privileged modification.

Do not store secrets, keyrings, credentials, host state, or generated account data in the repository. A migration belongs in provisioning only when a concrete existing installation needs it; otherwise configure the clean-install end state directly.

## Uninstall And Existing Machines

Keep link ownership symmetric with the uninstall scripts. Package and service removal is intentionally separate from unlinking dotfiles unless the repository explicitly changes that contract.

Do not assume a clean home. Stow may need to merge with application-created directories, especially the OpenCode configuration directory. Preserve unrelated files and inspect conflicts individually rather than deleting whole directories.

## Verification

- Run `bash -n` on changed shell scripts.
- Run `shellcheck` when available and assess warnings in context.
- Confirm new installer scripts retain executable mode and can be invoked through their orchestrator.
- Run focused parsers or validators for changed configuration formats.
- Use Stow simulation for each affected package and platform path.
- Confirm new symlinks resolve and tracked links remain links.
- Verify package names against their intended source.
- Check installer ordering and uninstall symmetry in the diff.
- Test both platform branches when shared setup changes.
- State any privileged, reboot, login, firmware, or hardware validation that was not performed.
- Run `git diff --check`.
