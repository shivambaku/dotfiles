-- Globals
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.netrw_banner = 0

-- Options
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.colorcolumn = "80"
vim.opt.cmdheight = 0

-- Keymapping
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Interested
-- vim.api.nvim_set_keymap("n", "E", "$", {noremap=false})
-- vim.api.nvim_set_keymap("n", "B", "^", {noremap=false})
-- vim.api.nvim_set_keymap("n", "ss", ":noh<CR>", {noremap=true})
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
