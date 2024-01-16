return {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
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
            version = "v2.*",
            build = "make install_jsregexp",
            dependencies = "rafamadriz/friendly-snippets",
        },

    },
    config = function()
        local lsp_zero = require("lsp-zero")
        local formatting_augroup = vim.api.nvim_create_augroup("LspFormatting", {})

        -- Disable highlight since we use treesitter
        lsp_zero.set_server_config({
            on_init = function(client)
                client.server_capabilities.semanticTokensProvider = nil
            end,
        })

        lsp_zero.set_sign_icons({
            error = "E",
            warn = "W",
            hint = "H",
            info = "I",
        })


        lsp_zero.on_attach(function(client, bufnr)
            local opts = function(desc)
                return { buffer = bufnr, remap = false, desc = desc }
            end

            -- Auto format on save
            if client.supports_method("textDocument/formatting") then
                vim.api.nvim_clear_autocmds({ group = formatting_augroup, buffer = bufnr })
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = formatting_augroup,
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({ async = false })
                    end,
                })
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

        -- Automatic language server config
        local lspconfig = require("lspconfig")
        require('mason').setup({})
        require('mason-lspconfig').setup({
            ensure_installed = { 'tsserver', 'rust_analyzer', 'gopls' },
            handlers = {
                lsp_zero.default_setup,
                lua_ls = function()
                    local lua_opts = lsp_zero.nvim_lua_ls()
                    lspconfig.lua_ls.setup(lua_opts)
                end,
                tsserver = function()
                    lspconfig.tsserver.setup({
                        on_attach = function(_, bufnr)
                            -- For tsserver we don't want the format on save.
                            vim.api.nvim_clear_autocmds({ group = formatting_augroup, buffer = bufnr })
                        end
                    })
                end,
                eslint = function()
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
                            vim.api.nvim_clear_autocmds({ group = formatting_augroup, buffer = bufnr })
                            vim.api.nvim_create_autocmd("BufWritePre", {
                                group = formatting_augroup,
                                buffer = bufnr,
                                callback = function()
                                    vim.cmd("EslintFixAll")
                                end,
                            })
                        end,
                    })
                end,
                rust_analyzer = function()
                    lspconfig.rust_analyzer.setup({
                        -- Server-specific settings. See `:help lspconfig-setup`
                        settings = {
                            ['rust-analyzer'] = {
                                cargo = {
                                    -- Run the anlyzer with all the features
                                    -- features = { "all" },
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
                    })
                end,
                gopls = function()
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
                            vim.api.nvim_clear_autocmds({ group = formatting_augroup, buffer = bufnr })
                            vim.api.nvim_create_autocmd('BufWritePre', {
                                group = formatting_augroup,
                                buffer = bufnr,
                                pattern = '*.go',
                                callback = function()
                                    vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
                                end
                            })
                        end
                    })
                end,
            }
        })

        -- cmp config
        local cmp = require("cmp")
        local cmp_format = lsp_zero.cmp_format()
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        local cmp_mappings = {
            ["<Up>"] = cmp.mapping.select_prev_item(cmp_select),
            ["<Down>"] = cmp.mapping.select_next_item(cmp_select),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<C-x>"] = cmp.mapping.abort(),
            ["<C-Space>"] = cmp.mapping.complete(),
            -- scroll up and down the documentation window
            ['<C-u>'] = cmp.mapping.scroll_docs(-4),
            ['<C-d>'] = cmp.mapping.scroll_docs(4),
        }

        -- snippets
        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
            formatting = cmp_format,
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
