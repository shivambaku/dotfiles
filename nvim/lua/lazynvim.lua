-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

-- tokyonight
vim.cmd[[colorscheme tokyonight-night]]

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files)
vim.keymap.set('n', '<leader>fp', builtin.git_files)
vim.keymap.set('n', '<leader>fg', builtin.live_grep)
vim.keymap.set('n', '<leader>fh', builtin.help_tags)
vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols)

-- harpoon
local harpoon = require("harpoon")

harpoon:setup()

vim.keymap.set("n", "<M-h>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<M-1>", function() harpoon:list():replace_at(1) end)
vim.keymap.set("n", "<M-2>", function() harpoon:list():replace_at(2) end)
vim.keymap.set("n", "<M-3>", function() harpoon:list():replace_at(3) end)
vim.keymap.set("n", "<M-4>", function() harpoon:list():replace_at(4) end)
vim.keymap.set("n", "<M-5>", function() harpoon:list():replace_at(5) end)

vim.keymap.set("n", "<M-!>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<M-@>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<M-#>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<M-$>", function() harpoon:list():select(4) end)
vim.keymap.set("n", "<M-%>", function() harpoon:list():select(5) end)
