require("manu.set")
require("manu.remap")

-- Load secrets
local secrets = require("helper.secrets")
secrets.load_secrets()

-- Initialize lazy

local lazyPath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazyPath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazyPath,
    })
end
vim.opt.rtp:prepend(lazyPath)

require("lazy").setup("manu.plugins", {
    defaults = {
        lazy = true,
    },
})

-- Load config
require("manu.config")
