return {
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", ft = { "sql" }, lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		config = function()
			local theme = require("theme")

			vim.g.db_ui_use_nerd_fonts = 1

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "dbui",
				callback = function()
					vim.api.nvim_set_hl(0, "dbui_connection_ok", theme.groups.dbui_connection_ok)
					vim.api.nvim_set_hl(0, "dbui_connection_error", theme.groups.dbui_connection_error)
				end,
			})
		end,
	},
}
