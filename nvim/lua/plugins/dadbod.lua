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
		init = function()
			-- Your DBUI configuration
			vim.g.db_ui_use_nerd_fonts = 1
		end,
		config = function()
			vim.api.nvim_create_user_command("SetDatabaseURL", function()
				-- Get the current line and cursor position
				local line = vim.api.nvim_get_current_line()

				-- Find the nearest quoted string around the cursor
				local _, match, _ = line:match('^(.-)"([^"]+)"(.*)$')

				if match then
					-- Set the environment variable
					vim.fn.setenv("DATABASE_URL", match)
					print("DATABASE_URL set to: " .. match)
				else
					print("No quoted string found near the cursor.")
				end
			end, { desc = "Set DATABASE_URL from the nearest quoted string" })
		end,
	},
}
