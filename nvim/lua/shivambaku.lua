-- https://neovim.io/doc/user/options.html

-- Globals
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.netrw_banner = 0

-- Options
vim.opt.backup = false
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 0
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.scrolloff = 8
vim.opt.shiftwidth = 4
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.softtabstop = 4
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.wrap = false

-- Keymapping
vim.keymap.set("n", "<Esc>", "<CMD>noh<CR>")
vim.keymap.set("n", "<leader>w", "<CMD>w<CR>", { desc = "Save buffer" })
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("n", "<BS>", "<C-6>")

-- User Commands
vim.api.nvim_create_user_command("SetDatabaseURL", function()
	local line = vim.api.nvim_get_current_line()
	local _, match, _ = line:match('^(.-)"([^"]+)"(.*)$')
	if match then
		vim.fn.setenv("DATABASE_URL", match)
		print("DATABASE_URL set to: " .. match)
	else
		print("No quoted string found near the cursor.")
	end
end, { desc = "Set DATABASE_URL from the nearest quoted string" })

-- Autocmds
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = augroup("highlight-yank", {}),
	callback = function()
		vim.highlight.on_yank()
	end,
})
