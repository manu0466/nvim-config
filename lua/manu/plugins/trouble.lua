return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    },
    cmd = "TroubleToggle",
    keys = {
        { "<leader>vD", "<cmd>TroubleToggle<cr>", desc = "Diagnostic Summary" },
    }
}
