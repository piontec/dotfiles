-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("i", "jj", "<esc>", {})
vim.keymap.set("n", "<F7>", function()
  require("neo-tree.command").execute({ toggle = true, dir = require("lazyvim.util").get_root() })
end, {})
