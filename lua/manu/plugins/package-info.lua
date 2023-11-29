return {
    "vuki656/package-info.nvim",
    dependencies = {
        { "MunifTanjim/nui.nvim" },
    },
    event = "VeryLazy",
    config = function()
        require('package-info').setup({
            colors = {
                up_to_date = "#3C4048", -- Text color for up to date dependency virtual text
                outdated = "#d19a66", -- Text color for outdated dependency virtual text
            },
            icons = {
                enable = true, -- Whether to display icons
                style = {
                    up_to_date = "|  ", -- Icon for up to date dependencies
                    outdated = "|  ", -- Icon for outdated dependencies
                },
            },
            autostart = true,        -- Whether to autostart when `package.json` is opened
            hide_up_to_date = false, -- It hides up to date versions when displaying virtual text
            hide_unstable_versions = false, -- It hides unstable versions from version list e.g next-11.1.3-canary3
            package_manager = "yarn",
        })
    end,
    keys = {
        {
            "<leader>vs",
            function()
                require("package-info").show()
            end,
            mode = { "n" },
            desc = "Show dependency versions",
        },
        {
            "<leader>vh",
            function()
                require("package-info").hide()
            end,
            mode = { "n" },
            desc = "Hide dependency versions",
        },
        {
            "<leader>vt",
            function()
                require("package-info").toggle()
            end,
            mode = { "n" },
            desc = "Toggle dependency versions",
        },
        {
            "<leader>vu",
            function()
                require("package-info").update()
            end,
            mode = { "n" },
            desc = "Update dependency on the line",
        },
    },
}
