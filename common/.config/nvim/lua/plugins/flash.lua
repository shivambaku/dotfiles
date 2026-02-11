return {
	"folke/flash.nvim",
	keys = { "s", "S" },
	config = function()
		local flash = require("flash")
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

		vim.api.nvim_set_hl(0, "FlashCurrent", { bold = true, fg = "#ff0000" })

		vim.keymap.set({ "n", "x", "o" }, "s", flash.jump, { desc = "Flash jump" })
		vim.keymap.set({ "n", "x", "o" }, "S", flash.treesitter, { desc = "Flash treesitter" })
	end,
}
