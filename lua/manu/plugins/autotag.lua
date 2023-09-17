return {
    'windwp/nvim-ts-autotag',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
    },
    event = "BufEnter",
    config = function()
        require('nvim-treesitter.configs').setup {
            autotag = {
                enable = true,
            }
        }
    end,
}
