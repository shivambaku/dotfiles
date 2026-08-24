# Biei

Biei is a cool, low-chroma dark theme inspired by the snow-covered fields of
Biei, Hokkaido at blue hour. Lists use `Muted` for inactive labels and `Text` on
`Selection` for the active row. Desktop UI, terminals, and editors use Commit
Mono Nerd Font.

## Palette

```text
Base       #05070A    Surface    #13181E    Selection  #223246
Border     #3A4652    Text       #E1E8EC    Muted      #7D8992
Secondary  #B8C3CA    Blue       #7FB5E5    Ice        #A9CCE8
Cyan       #78BBC4    Green      #9CB68E    Violet     #B3A1D6
Number     #D0A17E    Warning    #D3B26F    Error      #D9858B
```

Theme files are linked into place by the dotfiles installer. Wallpaper exports
live in `~/.local/share/backgrounds/hokkaido-snow/`.

## Refresh

Hyprland and Noctalia watch their configuration files. WezTerm also watches its
shared theme. Only cached or copied themes need an explicit refresh:

```bash
bat cache --build                 # after changing the Bat theme
auto-zen-configure-profiles       # after changing Zen CSS or managed preferences
```

Restart Zen after updating its profile CSS. Stow is only needed during setup or
after adding a new path that the installer has not linked yet.
