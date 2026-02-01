return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function()
        local conform = require("conform")
        conform.setup({
            formatters_by_ft = {
                sql = { "sqlfmt" },
                json = { "jq" },
                sh = { "shfmt" },
                php = { "ddev_pint" },
                nix = { "nixfmt" },
            },
            format_on_save = {
                lsp_fallback = true,
                async        = false,
                timeout_ms   = 5000,
            },
            formatters = {
                ddev_pint = {
                    command     = "ddev",
                    args        = { "pint", "--silent", "$RELATIVE_FILEPATH" },
                    stdin       = false,
                    -- A function that calculates the directory to run the command in
                    cwd         = require("conform.util").root_file({ "pint.json" }),
                    -- When cwd is not found, don't run the formatter (default false)
                    require_cwd = true,
                    condition   = function(self, ctx)
                        cwd = self.cwd(self, ctx)
                        if cwd == nil then
                            return false
                        end
                        -- ctx.cwd is the project root (Conform’s run cwd)
                        local target = cwd .. "/.ddev/commands/web/pint"
                        return vim.uv.fs_stat(target) ~= nil
                    end,
                    timeout_ms  = 5000,
                },
            }
        })
    end,
    keys = {
        {
            -- Customize or remove this keymap to your liking
            "<leader>ft",
            function()
                require("conform").format({ async = true })
            end,
            mode = "n",
            desc = "Format buffer",
        },
    },
}
