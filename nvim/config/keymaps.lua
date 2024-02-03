local keymap = vim.keymap
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "

-- select all
keymap.set("n", "<C-a>", "gg<S-v>G")

keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

keymap.set("n", "J", "mzJ`z")
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

-- next greatest remap ever : asbjornHaland
keymap.set({ "n", "v" }, "<leader>y", [["+y]])
keymap.set("n", "<leader>Y", [["+Y]])

-- This is going to get me cancelled
keymap.set("i", "<C-c>", "<Esc>")
