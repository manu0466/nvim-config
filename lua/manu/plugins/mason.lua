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
            "phpantom_lsp",
            "laravel_lsp",
            -- nix
            "nil",
            "nixfmt",
            -- Python
            "python-lsp-server",
            -- Golang
            "gopls",
            -- Rust
            "rust-analyzer",
            -- Arduino
            "arduino-language-server",
            -- Markdown
            "marksman",
            -- Latex
            "digestif",
            "latexindent",
            -- Yaml
            "yaml-language-server",
            -- Bash
            "shfmt",
            -- SQL
            "sqlfmt",
        }
    },
    lazy = false,
}
