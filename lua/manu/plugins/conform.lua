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
            },
            format_on_save = {
                lsp_fallback = true,
                async = false,
            },

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
