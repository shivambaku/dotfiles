return {
	"folke/flash.nvim",
	keys = { "s", "S" },
	config = function()
		local flash = require("flash")
		flash.setup({
			highlight = {
				backdrop = false,
				current = false,
				groups = {
					match = "FlashMatch",
					current = "FlashMatch",
					label = "FlashCurrent",
				},
			},
			modes = {
				char = {
					enabled = false,
				},
			},
		})
		vim.keymap.set({ "n", "x", "o" }, "s", flash.jump, { desc = "Flash jump" })
		vim.keymap.set({ "n", "x", "o" }, "S", flash.treesitter, { desc = "Flash treesitter" })
	end,
}
