# Theme Maintenance

## Change The Theme

1. Replace the files in this directory without changing their filenames.
2. Preserve the existing return fields in the Lua files.
3. Update the manual colors listed below.
4. Apply the changes.

## Manual Colors

- LazyGit and LazyDocker GUI colors
- Noctalia workspace and lockscreen colors

## Apply Changes

```bash
bat cache --build
noctalia msg config-reload
auto-zen-configure-profiles
```

## Add An Application

1. Add the application's native theme file to this directory.
2. Point the application directly to the new file when possible.
3. If the application requires a fixed location, create a relative symlink to
   the new file. Make the link relative to its repository location, not
   `~/.config`.
4. Update the application's selected theme name if needed.
5. From the repository root, restow:

   ```sh
   stow -R -d "$PWD" -t "$HOME" common
   stow -R -d "$PWD/linux" -t "$HOME" stow
   ```

6. Verify the installed theme path with `realpath -e`.
