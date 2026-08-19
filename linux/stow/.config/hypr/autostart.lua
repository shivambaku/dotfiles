hl.on("hyprland.start", function()
	hl.exec_cmd("systemctl --user start voxtype.service")
	hl.exec_cmd("auto-zen-sync-launchers && noctalia --daemon")
end)
