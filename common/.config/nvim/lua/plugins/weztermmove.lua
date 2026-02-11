return {
	"letieu/wezterm-move.nvim",
	config = function()
		local wezterm_move = require("wezterm-move")

		vim.keymap.set("n", "<C-w>h", function()
			wezterm_move.move("h")
		end)
		vim.keymap.set("n", "<C-w>j", function()
			wezterm_move.move("j")
		end)
		vim.keymap.set("n", "<C-w>k", function()
			wezterm_move.move("k")
		end)
		vim.keymap.set("n", "<C-w>l", function()
			wezterm_move.move("l")
		end)
	end,
}
