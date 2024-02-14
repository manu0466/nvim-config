return {
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        lazy = true,
        config = false,
        init = function()
            -- Disable automatic setup, we are doing it manually
            vim.g.lsp_zero_extend_cmp = 0
            vim.g.lsp_zero_extend_lspconfig = 0
        end,
    },
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = true,
    },

    -- Auto completion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "saadparwaiz1/cmp_luasnip" },
            {
                -- Snippet plugin
                "L3MON4D3/LuaSnip",
                version = "v2.*",
                build = "make install_jsregexp",
                dependencies = "rafamadriz/friendly-snippets",
            },
            { "f3fora/cmp-spell" },
        },
        config = function()
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_cmp()

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
                    {
                        name = 'spell',
                        option = {
                            keep_all_entries = false,
                            enable_in_context = function()
                                return require('cmp.config.context').in_treesitter_capture('spell')
                            end,
                        },
                    },
                },
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                mapping = cmp_mappings
            })
        end
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'williamboman/mason-lspconfig.nvim' },
            {
                'yuchanns/shfmt.nvim',
                opts = { "-i=4" },
                lazy = true
            },
        },
        config = function()
            local lsp_zero = require("lsp-zero")

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

            -- Auto format on save
            local formatting_augroup = vim.api.nvim_create_augroup("LspFormatting", {})
            local init_format_on_save = function(client, bufnr)
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_clear_autocmds({ group = formatting_augroup, buffer = bufnr })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = formatting_augroup,
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ async = false })
                        end,
                    })
                elseif client.name == "bashls" then
                    vim.api.nvim_clear_autocmds({ group = formatting_augroup, buffer = bufnr })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = formatting_augroup,
                        buffer = bufnr,
                        callback = function()
                            require("shfmt").formatting()
                        end,
                    })
                end
            end

            lsp_zero.on_attach(function(client, bufnr)
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

                vim.keymap.set("n", "<leader>ft", function()
                    if client.name == 'bashls' then
                        require("shfmt").formatting()
                    else
                        vim.lsp.buf.format()
                    end
                end, opts("LSP: Format Text"))
            end)

            -- Automatic language server config
            local lspconfig = require("lspconfig")
            require('mason').setup({})
            require('mason-lspconfig').setup({
                ensure_installed = { 'tsserver', 'rust_analyzer', 'gopls', 'lua_ls' },
                handlers = {
                    lsp_zero.default_setup,
                    lua_ls = function()
                        local lua_opts = lsp_zero.nvim_lua_ls()
                        local original_on_attach = lua_opts.on_attach
                        lua_opts.on_attach = function(client, bufnr)
                            init_format_on_save(client, bufnr)
                            if original_on_attach then
                                original_on_attach(client, bufnr)
                            end
                        end

                        lspconfig.lua_ls.setup(lua_opts)
                    end,
                    tsserver = function()
                        lspconfig.tsserver.setup({})
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
                                        -- Run the analyzer with all the features
                                        -- features = { "all" },
                                    },
                                    check = {
                                        -- Use cargo clippy to check the code instead of
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
                            on_attach = function(client, bufnr)
                                init_format_on_save(client, bufnr)
                            end,
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
                    bashls = function()
                        lspconfig.bashls.setup({
                            on_attach = function(client, bufnr)
                                init_format_on_save(client, bufnr)
                            end,
                        })
                    end
                }
            })

            vim.diagnostic.config({
                virtual_text = true,
            })
        end,
    },
}
