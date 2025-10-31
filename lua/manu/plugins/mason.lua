return {
    'owallb/mason-auto-install.nvim',
    dependencies = {
        {
            'williamboman/mason.nvim',
            config = true,
        }
    },
    opts = {
        packages = {
            -- LUA
            "lua-language-server",
            -- PHP
            "phpactor",
            "laravel-ls",
            -- Python
            "python-lsp-server",
            -- Golang
            "gopls",
            -- Rust
            "rust-analyzer",
            -- Arduino
            "arduino-language-server",
            -- Solidity
            "nomicfoundation-solidity-language-server",
            -- Markdown
            "marksman",
            -- Yaml
            "yaml-language-server",

            "shfmt",
            "sqlfmt",
        }
    },
    lazy = false,
}
