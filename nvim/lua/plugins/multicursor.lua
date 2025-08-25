return {
	"jake-stewart/multicursor.nvim",
	event = "VeryLazy",
	config = function()
		local mc = require("multicursor-nvim")
		mc.setup()

		vim.api.nvim_set_hl(0, "MultiCursorCursor", { fg = "#12131b", bg = "#868dac" })

		vim.keymap.set("n", "<esc>", function()
			if not mc.cursorsEnabled() then
				mc.enableCursors()
			elseif mc.hasCursors() then
				mc.clearCursors()
			else
				vim.cmd("noh")
			end
		end)

		vim.keymap.set({ "n", "v" }, "<Tab>", mc.toggleCursor)
		-- vim.keymap.set({ "n", "v" }, "q", mc.nextCursor)
		-- vim.keymap.set({ "n", "v" }, "Q", mc.prevCursor)
		vim.keymap.set({ "n", "v" }, "<C-n>", function()
			mc.matchAddCursor(1)
		end)
		vim.keymap.set({ "n", "v" }, "<C-q>", function()
			mc.matchSkipCursor(1)
		end)
	end,
}
