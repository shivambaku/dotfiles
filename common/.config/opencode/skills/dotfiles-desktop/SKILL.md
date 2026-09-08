---
name: dotfiles-desktop
description: Use ONLY when work concerns the Linux desktop in this dotfiles-managed repository or workstation, including Hyprland, Noctalia, workspaces, window rules, keybindings, startup applications, launchers, Zen profiles or web apps, screenshots, and lock behavior. Explains discovery, ownership, runtime identity, and validation without assuming current assignments.
---

# Dotfiles Desktop

Change desktop behavior by following the existing component boundaries and inspecting live identities instead of guessing them.

## Source Map

- Hyprland source lives under `linux/stow/.config/hypr/` and is composed from the modules required by `hyprland.lua`.
- Noctalia's tracked configuration lives under `linux/stow/.config/noctalia/`; its runtime state is not repository configuration.
- User commands and XDG desktop entries live under `linux/local/.local/`.
- Runtime-generated browser profiles, portal launchers, application state, and secret storage remain outside the repository.

Read the entrypoint and the relevant module before editing. Search bindings, startup commands, window rules, desktop entries, and helper scripts for an existing convention.

## Choose The Correct Layer

- Put monitor topology in the monitor module.
- Put input devices and gestures in the input module.
- Put visual compositor behavior and general window rules in the look-and-feel module.
- Put daemon and session initialization in the autostart module.
- Put keyboard, mouse, media, and application shortcuts in the bindings module.
- Put focused feature behavior in its existing dedicated module rather than enlarging unrelated modules.
- Put shell, bar, launcher, lock screen, and notification settings in Noctalia configuration when Noctalia owns the feature.

Follow the current module graph rather than treating this list as permanent; new focused modules may be appropriate when behavior is cohesive.

## Windows And Workspaces

1. Inspect existing rules and bindings for conflicts.
2. Launch the application through the same desktop entry or helper the user normally invokes.
3. Inspect the resulting client with `hyprctl clients` or its JSON output.
4. Use observed class, initial class, title, and process behavior to choose a stable rule.
5. Prefer class-based placement for applications that start slowly, hand off through Flatpak or a portal, or reuse an existing process.
6. Avoid timing delays when a lifecycle event or stable window identity can express the requirement.
7. Test a clean launch, an already-running launch, and navigation away from the originating workspace when relevant.

Do not infer a window class from an executable or desktop filename. Browser task apps and generated web apps may have distinct runtime classes and launch commands.

## Startup

The Hyprland start event runs only for a new compositor session. A configuration reload can validate syntax but does not retest login behavior.

Keep startup commands declarative and minimal. Use existing desktop entries when the requirement is to launch an application as the graphical launcher does. Confirm whether an application restores its own session or reuses an existing process before assigning placement.

When full startup behavior matters, validate the configuration first and then ask the user before logging out or restarting the compositor. Prefer giving the user a clear logout/login test when the current session contains unsaved work or OpenCode itself. Do not claim startup was exercised after only running `hyprctl reload`.

## Noctalia

Separate tracked configuration from GUI-managed state. If the tracked source looks correct but runtime behavior differs:

1. Query the effective setting when Noctalia exposes an IPC command.
2. Inspect recent user-service or application logs.
3. Check runtime state for an overriding value.
4. Remove or adjust only the narrow stale override when appropriate.

Do not track the whole state file. It may contain account details, discovered data, or settings intentionally owned by the GUI. Never expose or modify stored secrets while diagnosing configuration.

## Launchers And Browser Profiles

Treat `.desktop` files as the contract used by graphical launchers. Inspect `Exec`, `TryExec`, class metadata, and the actual resulting window before reusing a launcher command.

Generated Zen profile and web-app identifiers are runtime data. Use the repository's profile helpers and existing generated desktop entries where possible. Do not bake a profile display name, UUID, or machine-generated path into generic configuration without confirming that it is intended to persist.

## Safety

- Prefer read-only runtime inspection before changing active desktop state.
- Do not edit installed application source or generated state when a tracked override or helper is the intended extension point.
- Do not add arbitrary sleeps to solve ordering without first identifying the actual lifecycle.
- Do not log out, restart the compositor, lock the session, or terminate graphical applications without explicit user approval.
- Keep theme values in the centralized theme system and load `dotfiles-theme` for changes crossing that boundary.
- Keep new user-facing utility behavior consistent with `dotfiles-terminal-tools`.

## Verification

- Parse changed Lua files with an available Lua parser.
- Reload Hyprland and check `hyprctl configerrors` when a live session is available.
- Run Noctalia's configuration validation before requesting a reload.
- Validate changed desktop entries with `desktop-file-validate` when available.
- Refresh the user desktop database after deploying launcher changes.
- Verify client identity and workspace placement from runtime data rather than visual assumption.
- Clearly report when login-only, lock-screen, monitor, or hardware behavior could not be exercised.
- Run `git diff --check`.
