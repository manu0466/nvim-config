require("manu.set")
require("manu.remap")

-- Load secrets

local secrets = require("helper.secrets")
secrets.load_secrets()

-- Initialize lazy

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("manu.plugins", {
    defaults = {
        lazy = true,
    },
})
