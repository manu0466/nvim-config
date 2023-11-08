return {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    lazy = false,
    dependencies = {
        -- LSP Support
        { "neovim/nvim-lspconfig" },             -- Required
        { "williamboman/mason.nvim" },           -- Optional
        { "williamboman/mason-lspconfig.nvim" }, -- Optional

        -- Autocompletion
        { "hrsh7th/nvim-cmp",                 lazy = true },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "saadparwaiz1/cmp_luasnip" },
        {
            -- snippet plugin
            "L3MON4D3/LuaSnip",
            dependencies = "rafamadriz/friendly-snippets",
        },

    },
    config = function()
        local lsp = require("lsp-zero")
        lsp.preset("minimal")
        lsp.ensure_installed({
            "tsserver",
            "rust_analyzer",
        })

        -- Disable highlight since we use treesitter
        lsp.set_server_config({
            on_init = function(client)
                client.server_capabilities.semanticTokensProvider = nil
            end,
        })

        -- Fix Undefined global 'vim'
        lsp.nvim_workspace()

        lsp.set_preferences({
            suggest_lsp_servers = false,
            sign_icons = {
                error = "E",
                warn = "W",
                hint = "H",
                info = "I",
            },
        })

        lsp.on_attach(function(_, bufnr)
            local opts = function(desc)
                return { buffer = bufnr, remap = false, desc = desc }
            end

            vim.keymap.set("n", "gd", function()
                require("telescope.builtin").lsp_definitions()
            end, opts("LSP: go to definition"))

            vim.keymap.set("n", "K", function()
                vim.lsp.buf.hover()
            end, opts("LSP: Hover"))

            vim.keymap.set("n", "<leader>ws", function()
                require("telescope.builtin").lsp_dynamic_workspace_symbols()
            end, opts("LSP: Workspace Symbols"))

            vim.keymap.set("n", "<leader>cD", function()
                vim.diagnostic.open_float()
            end, opts("LSP: Show Diagnostics"))

            vim.keymap.set("n", "[d", function()
                vim.diagnostic.goto_next()
            end, opts("LSP: Next Diagnostic"))

            vim.keymap.set("n", "]d", function()
                vim.diagnostic.goto_prev()
            end, opts("LSP: Prev Diagnostic"))

            vim.keymap.set("n", "<a-cr>", function()
                vim.cmd("CodeActionMenu")
            end, opts("LSP: Code Actions"))

            vim.keymap.set("n", "<leader>crr", function()
                require("telescope.builtin").lsp_references()
            end, opts("LSP: References"))

            vim.keymap.set("n", "<leader>crn", function()
                vim.lsp.buf.rename()
            end, opts("LSP: Rename"))

            vim.keymap.set("n", "<leader>cic", function()
                require("telescope.builtin").lsp_incoming_calls()
            end, opts("LSP: Incoming Calls"))

            vim.keymap.set("n", "<leader>coc", function()
                require("telescope.builtin").lsp_outgoing_calls()
            end, opts("LSP: Outgoing Calls"))

            vim.keymap.set("i", "<C-h>", function()
                vim.lsp.buf.signature_help()
            end, opts("LSP: Signature Help"))

            vim.keymap.set("n", "<leader>tf", function()
                vim.lsp.buf.format()
            end, opts("LSP: Format"))
        end)

        local lspconfig = require("lspconfig")

        -- Configure lua language server for neovim

        lspconfig.lua_ls.setup(lsp.nvim_lua_ls())

        -- eslint

        lspconfig.eslint.setup({
            settings = {
                codeAction = {
                    disableRuleComment = {
                        enable = true,
                        location = "separateLine",
                    },
                    showDocumentation = {
                        enable = true,
                    },
                },
                codeActionOnSave = {
                    enable = true,
                    mode = "all",
                },
                experimental = {
                    useFlatConfig = false,
                },
                format = true,
                nodePath = "",
                onIgnoredFiles = "off",
                packageManager = "yarn",
                problems = {
                    shortenToSingleLine = false,
                },
                quiet = false,
                rulesCustomizations = {},
                run = "onType",
                useESLintClass = false,
                validate = "on",
                workingDirectory = {
                    mode = "location",
                },
            },
            on_attach = function(_, bufnr)
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    callback = function()
                        vim.cmd("EslintFixAll")
                    end,
                })
            end,
        })

        -- rust analyzer

        lspconfig.rust_analyzer.setup({
            -- Server-specific settings. See `:help lspconfig-setup`
            settings = {
                ['rust-analyzer'] = {
                    cargo = {
                        -- Run the anlyzer with all the features
                        features = { "all" },
                    },
                    check = {
                        -- Use carco clippy to check the code instead of
                        -- cargo check
                        overrideCommand = {
                            "cargo",
                            "clippy",
                            "--all-targets",
                            "--all-features",
                            "--message-format=json",
                        }
                    }
                },
            },
            on_attach = function(_, bufnr)
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    pattern = "*.rs",
                    callback = function()
                        -- Format on save
                        vim.lsp.buf.format()
                    end
                })
            end
        })

        -- gopls

        local util = require "lspconfig/util"

        lspconfig.gopls.setup({
            cmd = { "gopls", "serve" },
            filetypes = { "go", "gomod" },
            root_dir = util.root_pattern("go.work", "go.mod"),
            settings = {
                gopls = {
                    analyses = {
                        unusedparams = true,
                    },
                    staticcheck = true,
                },
            },
            on_attach = function(_, bufnr)
                vim.api.nvim_create_autocmd('BufWritePre', {
                    buffer = bufnr,
                    pattern = '*.go',
                    callback = function()
                        vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
                    end
                })
            end
        })


        lsp.setup()

        local cmp = require("cmp")
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        local cmp_mappings = {
            ["<Up>"] = cmp.mapping.select_prev_item(cmp_select),
            ["<Down>"] = cmp.mapping.select_next_item(cmp_select),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<C-Space>"] = cmp.mapping.complete(),
        }
        -- snippets
        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
            sources = {
                { name = "nvim_lsp" },
                { name = "buffer" },
                { name = "path" },
                { name = "luasnip" },
            },
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            mapping = cmp_mappings
        })

        vim.diagnostic.config({
            virtual_text = true,
        })
    end,
}
