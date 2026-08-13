export PATH="$HOME/.local/bin:$PATH"
export XDG_DATA_DIRS="$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"

if [[ -z ${WAYLAND_DISPLAY:-} && ${XDG_VTNR:-0} == 1 ]]; then
	exec start-hyprland
fi
