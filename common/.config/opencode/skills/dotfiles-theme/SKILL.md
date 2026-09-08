---
name: dotfiles-theme
description: Use ONLY when work concerns the centralized theme in this dotfiles-managed repository or workstation, including replacing a color scheme, changing palette semantics, tracing consumers, or adding theme support for an application. Explains the static native-file bundle, direct loaders, discovery symlinks, synchronization, validation, and reload workflow without assuming a particular theme.
---

# Dotfiles Theme

Maintain the theme as a replaceable system, not as a collection tied to the current theme name or palette.

## Locate The Source

When working inside the dotfiles repository, treat `common/.config/dotfiles/theme/` as the source. When starting from a deployed configuration, resolve its links back to the repository before editing. Do not assume a checkout location.

Read the bundle's `README.md` and native theme files to learn the current theme identity, palette, semantic roles, and manual refresh requirements. Never copy current color values or the current visual name into this skill's workflow.

## Architecture

The theme directory is a static bundle of final, application-native files. It is intentionally not a normalized palette schema, template tree, generated output directory, or theme switcher.

The bundle uses `dotfiles` as a stable technical identifier where an application-facing adapter permits it. Some native payloads may expose another internal or application-specific name; discover and preserve those interfaces unless deliberately migrating them.

Consumers use one of four integration models:

1. Direct load: application configuration imports a file from the central theme directory.
2. Fixed discovery: a repository-relative symlink exposes a central file at the path an application requires.
3. Synchronized copy: a helper copies a central file into runtime-managed locations that cannot be owned safely by Stow.
4. Embedded setting: colors that cannot be separated from behavioral configuration remain with that application and must be discovered during theme work.

Do not assume the current set of consumers is exhaustive. Discover it by searching for references to `dotfiles/theme`, inspecting tracked symlinks, checking synchronization helpers, and searching tracked configuration for distinctive current palette values and theme identifiers. Classify each hit as a native payload, embedded manual setting, unrelated content, or stale theme value.

## Replace The Theme

1. Read the current bundle and identify the semantic role of every color before changing values.
2. Preserve filenames, native file formats, exported Lua shapes, stable adapter identifiers, and discovered application-specific interfaces unless the integration itself must change.
3. Replace each application-native representation with the new theme's equivalent roles.
4. Keep behavioral settings outside the bundle unless an application provides a clean theme-only file or include boundary.
5. Update the bundle README to describe the new theme and its semantic palette.
6. Run format validation, refresh caches and synchronized copies, and reload or restart consumers.

A replacement is complete only when the entire bundle intentionally represents one theme. Do not update only the applications visible in a screenshot.

## Add A Consumer

1. Determine whether the application is shared, Linux-only, or macOS-only.
2. Determine whether it supports an arbitrary theme path, requires discovery in a fixed directory, or stores colors inside mixed configuration.
3. Add a final native theme file to the central bundle when the application has a meaningful theme boundary.
4. Prefer a direct load when supported.
5. Otherwise add a relative symlink in the application's expected repository path. Confirm Git records it as a symlink rather than a copied file.
6. Use a synchronization helper only when the destination is runtime-generated or outside safe Stow ownership.
7. Keep manual embedded colors in application configuration and document them instead of adding merge or generation machinery.
8. Test installation in a temporary Stow target before touching the live home when new links or directories are involved.

## Guardrails

- Never change the Stow deployment mode for theme work. `common` and `linux/stow` must remain normally folded.
- Never write generated theme output or cache data into the repository.
- Do not add a generator, selector, template engine, runtime `current` link, state directory, or hook framework unless explicitly requested.
- Do not replace an application's complete behavioral configuration merely to centralize a small color block.
- Do not introduce migration or legacy cleanup code without a concrete deployed state that still requires it.
- Preserve relative symlinks so the repository remains movable between machines.
- Inspect application state when the source is correct but the effective theme is not; persisted GUI state may override tracked configuration.

## Verification

- Validate JSON, TOML, YAML, XML, CSS, Lua, and shell files with the appropriate available parser or application command.
- Inspect every new symlink target and verify tracked links retain mode `120000`.
- Search for stale references to replaced theme names and distinctive old palette values when the replacement is intended to be complete.
- Exercise direct imports and application discovery paths from an isolated or temporary home when practical.
- Run required cache rebuild and synchronization commands from the current README or integration scripts.
- Reload live consumers where safe and state which applications still require restart or login.
- Run `git diff --check`.
