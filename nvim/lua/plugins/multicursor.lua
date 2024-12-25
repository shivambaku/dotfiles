return {
	"mg979/vim-visual-multi",
	event = "VeryLazy",
	config = function()
		vim.g.VM_silent_exit = true
		vim.g.VM_quit_after_leaving_insert_mode = true
		vim.api.nvim_set_hl(0, "VM_Extend", { bg = "#3d59a1", fg = "#c0caf5" })
		vim.api.nvim_set_hl(0, "VM_Cursor", { bg = "#3d59a1", fg = "#c0caf5" })
		-- vim.api.nvim_set_hl(0, "VM_Extend", { link = "Search" })
		-- vim.api.nvim_set_hl(0, "VM_Cursor", { link = "Search" })
	end,
}
