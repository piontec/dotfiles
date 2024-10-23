-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("i", "jj", "<esc>", {})
vim.keymap.set("n", "Y", "yy", { remap = true })
vim.keymap.set("n", "<F7>", "<leader>fe", { remap = true })
vim.keymap.set("n", "<C-_>", "gcc", { remap = true })
vim.keymap.set("n", '""', 'ysiW"', { remap = true })
