return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    config = function()
        local treesitter = require('nvim-treesitter')
        treesitter.setup {
            -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
            install_dir = vim.fn.stdpath('data') .. '/site'
        }

        -- Install required parsers
        local filetypes = {
            'lua',
            'rust',
            'php',
            'blade',
            'latex',
            'javascript', 'typescript', 'html', 'css',
            'json', 'yaml',
            'gitignore',
            'go', 'gomod',
            'nix'
        }
        treesitter.install(filetypes)

        vim.api.nvim_create_autocmd('FileType', {
            pattern = { 'javascriptreact', 'typescriptreact', 'tex', table.unpack(filetypes) },
            callback = function()
                -- syntax highlighting, provided by Neovim
                vim.treesitter.start()
                -- treesitter based indentation
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end
}
