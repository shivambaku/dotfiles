return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = function()
    local harpoon = require("harpoon")
    harpoon:setup()
  end,
  keys = function()
    local harpoon = require("harpoon")
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
  end,
}
