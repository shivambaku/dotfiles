# Biei

Biei is a cool, low-chroma dark theme inspired by the snow-covered fields of
Biei, Hokkaido at blue hour. Interfaces use neutral-black surfaces, pale text,
and restrained blue accents. Warm colors are reserved for syntax and status.

## Palette

```text
Base          #05070A    Deep       #0A0D11    Surface  #13181E
Raised        #1B232B    Selection  #223246    Border   #3A4652
Muted         #7D8992    Secondary  #B8C3CA    Text     #E1E8EC
Distant Blue  #6F9FD0    Blue       #7FB5E5    Ice     #A9CCE8
Cyan          #78BBC4    Green      #9CB68E    Violet   #B3A1D6
Peach         #D0A17E    Warning    #D3B26F    Error    #D9858B
```

Inactive items use `Muted`; selected items use `Text` on `Selection`. Blue and
Ice indicate focus, while Green, Warning, and Error communicate status.

Theme files are linked into place by the dotfiles installer. Run
`bat cache --build` after changing the Bat theme.
