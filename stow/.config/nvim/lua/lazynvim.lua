-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
	spec = (function()
		if vim.g.vscode then
			return {
				{ import = "plugins.flash" },
			}
		else
			return {
				{ import = "plugins" },
			}
		end
	end)(),
	checker = { enabled = true, notify = false },
	performance = {
		rtp = {
			disabled_plugins = {
				"man",
				"netrwPlugin",
				"spellfile",
				"tohtml",
				"tutor",
			},
		},
	},
})
