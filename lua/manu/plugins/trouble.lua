return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    },
    cmd = "Trouble",
    keys = {
        { "<leader>vD", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostic Summary" },
    }
}
