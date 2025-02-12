vim.g.mapleader = " "

-- Close neovim
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit" })

-- Get back Ctr-S to save
vim.keymap.set("n", "<C-s>", "<cmd>w<cr>")

-- Up/Down centered
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Move between search result keeping the cursor centered
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Window movement
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Yank into the system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank into system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line into system clipboard" })

-- Delete into void register
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Move highlighted code
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Editor actions
vim.keymap.set("n", "<leader>br", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Replace all occurrences" })
