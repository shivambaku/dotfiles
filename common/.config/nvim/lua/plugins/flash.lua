return {
	"folke/flash.nvim",
	keys = { "s", "S" },
	config = function()
		local flash = require("flash")
		local theme = require("theme")
		flash.setup({
			highlight = {
				backdrop = false,
				current = false,
				matches = false,
				groups = {
					match = "FlashMatch",
					eurrent = "FlashMatch",
					label = "FlashCurrent",
				},
			},
			modes = {
				char = {
					enabled = false,
				},
			},
		})

		vim.api.nvim_set_hl(0, "FlashCurrent", theme.highlights.flash_current)

		vim.keymap.set({ "n", "x", "o" }, "s", flash.jump, { desc = "Flash jump" })
		vim.keymap.set({ "n", "x", "o" }, "S", flash.treesitter, { desc = "Flash treesitter" })
	end,
}
