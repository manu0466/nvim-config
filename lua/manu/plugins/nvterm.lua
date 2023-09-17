return {
    "NvChad/nvterm",
    config = function()
        require("nvterm").setup({
            behavior = {
                autoclose_on_quit = {
                    enabled = false,
                    confirm = true,
                },
                close_on_exit = true,
                auto_insert = true,
            },
        })
    end,
    keys = {
        {
            "<A-t>",
            function() require("nvterm.terminal").toggle("float") end,
            mode = { "n", "t" },
            desc = "Toggle terminal"
        },
        {
            "<leader>tn",
            function()
                require("nvterm.terminal").new("float")
            end,
            desc = "New terminal"
        },
        {
            '<leader>tys',
            function()
                local nvterm = require("nvterm.terminal")
                nvterm.new("float")
                nvterm.send("yarn start")
            end,
            desc = 'Run yarn start'
        },
    }
}
