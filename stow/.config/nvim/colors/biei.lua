local theme = require("theme")

vim.o.background = "dark"
vim.cmd.highlight("clear")

if vim.fn.exists("syntax_on") == 1 then
	vim.cmd.syntax("reset")
end

vim.g.colors_name = "biei"

for name, value in pairs(theme.groups) do
	vim.api.nvim_set_hl(0, name, value)
end
