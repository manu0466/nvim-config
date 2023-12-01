-- netrw disbale for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Line number config
vim.opt.nu = true
vim.opt.relativenumber = true

-- Code identation config
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- History config
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- UI config
vim.opt.updatetime = 50
vim.opt.termguicolors = true
vim.opt.scrolloff = 12
vim.opt.colorcolumn = "80"

-- Folding
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
