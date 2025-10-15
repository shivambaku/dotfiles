return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		"<C-h>",
		"<C-1>",
		"<C-2>",
		"<C-3>",
		"<C-4>",
		"<C-5>",
		"<C-!>",
		"<C-@>",
		"<C-#>",
		"<C-$>",
		"<C-%>",
	},
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()

		vim.keymap.set("n", "<C-h>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end)
		vim.keymap.set("n", "<C-1>", function()
			harpoon:list():replace_at(1)
		end)
		vim.keymap.set("n", "<C-2>", function()
			harpoon:list():replace_at(2)
		end)
		vim.keymap.set("n", "<C-3>", function()
			harpoon:list():replace_at(3)
		end)
		vim.keymap.set("n", "<C-4>", function()
			harpoon:list():replace_at(4)
		end)
		vim.keymap.set("n", "<C-5>", function()
			harpoon:list():replace_at(5)
		end)
		vim.keymap.set("n", "<C-!>", function()
			harpoon:list():select(1)
		end)
		vim.keymap.set("n", "<C-@>", function()
			harpoon:list():select(2)
		end)
		vim.keymap.set("n", "<C-#>", function()
			harpoon:list():select(3)
		end)
		vim.keymap.set("n", "<C-$>", function()
			harpoon:list():select(4)
		end)
		vim.keymap.set("n", "<C-%>", function()
			harpoon:list():select(5)
		end)
	end,
}
