return {
	cmd = { "rust-analyzer" },
	filetypes = { "rs", "rust" },
	settings = {
		["rust-analyzer"] = {
			check = {
				command = "clippy",
				extraArgs = {
					"--",
					"--no-deps",
					"-Wclippy::all",
					"-Wclippy::nursery",
				},
			},
		},
	},
}
