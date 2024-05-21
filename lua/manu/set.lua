-- netrw disable for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Line number config
vim.opt.nu = true
vim.opt.relativenumber = true

-- Code indentation config
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
vim.opt.listchars = "eol:↵,tab:»·,trail:·,extends:→,precedes:←,nbsp:±"
vim.opt.list = true

-- Folding
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Spellcheck
vim.opt.spelllang = 'en_us'
vim.opt.spell = true
vim.opt.spelloptions = 'camel'
