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
                php = { "pint_vendor", "php-cs-fixer" },
                nix = { "nixfmt" },
                tex = { "latexindent" },
            },
            format_on_save = {
                lsp_fallback = true,
                async        = false,
                timeout_ms   = 5000,
            },
            formatters = {
                pint_vendor = {
                    command = function(_, ctx)
                        -- Find project root by looking for composer.json
                        local root_list = vim.fs.find("composer.json", { path = ctx.filename, upward = true })
                        local root_file = root_list[1]
                        if not root_file then
                            return nil -- no composer.json found → disable this formatter
                        end

                        -- Get the directory containing composer.json
                        local project_root = vim.fs.dirname(root_file)
                        if not project_root then
                            return nil
                        end

                        local pint_path = vim.fs.joinpath(project_root, "vendor", "bin", "pint")
                        -- Ensure pint_path is a string before calling executable()
                        if type(pint_path) == "string" and vim.fn.executable(pint_path) == 1 then
                            return pint_path
                        else
                            return nil
                        end
                    end,
                    args = { "$FILENAME" },
                    stdin = false,
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
