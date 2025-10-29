-- Load lsp config

-- Set default root markers for all clients
vim.lsp.config('*', {
    root_markers = { '.git' },
})

local lsps = {
    -- LUA
    "lua_ls",
    -- PHP
    "phpactor",
    "laravel_ls",
    -- Python
    "pylsp",
    -- Golang
    "gopls",
    -- Rust
    "rust_analyzer",
    -- Arduino
    "arduino_language_server",
    -- Solidity
    "solidity_ls_nomicfoundation",

    -- Markdown
    "marksman",
    -- Yaml
    "yamlls",
}

-- Enable configured lsp servers
vim.lsp.enable(lsps)

-- Configure formatting on save
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        local opts = function(desc)
            return { buffer = args.buf, remap = false, desc = desc }
        end

        vim.keymap.set("n", "gd", function()
            require("telescope.builtin").lsp_definitions()
        end, opts("LSP: go to definition"))

        vim.keymap.set("n", "K", function()
            vim.lsp.buf.hover()
        end, opts("LSP: Hover"))

        vim.keymap.set("n", "<leader>fs", function()
            require("telescope.builtin").lsp_dynamic_workspace_symbols()
        end, opts("LSP: Workspace Symbols"))

        vim.keymap.set("n", "<leader>vd", function()
            vim.diagnostic.open_float()
        end, opts("LSP: Show Diagnostics"))

        vim.keymap.set("n", "]d", function()
            vim.diagnostic.goto_next()
        end, opts("LSP: Next Diagnostic"))

        vim.keymap.set("n", "[d", function()
            vim.diagnostic.goto_prev()
        end, opts("LSP: Prev Diagnostic"))

        vim.keymap.set("n", "<leader>vrr", function()
            require("telescope.builtin").lsp_references()
        end, opts("LSP: References"))

        vim.keymap.set("n", "<leader>vrn", function()
            vim.lsp.buf.rename()
        end, opts("LSP: Rename"))

        vim.keymap.set("n", "<leader>vci", function()
            require("telescope.builtin").lsp_incoming_calls()
        end, opts("LSP: Calls Incoming"))

        vim.keymap.set("n", "<leader>vco", function()
            require("telescope.builtin").lsp_outgoing_calls()
        end, opts("LSP: Calls Outgoing"))

        vim.keymap.set("n", "<leader>vi", function()
            require("telescope.builtin").lsp_implementations()
        end, opts("LSP: Show implementations"))

        vim.keymap.set("i", "<C-h>", function()
            vim.lsp.buf.signature_help()
        end, opts("LSP: Signature Help"))
    end,
})
