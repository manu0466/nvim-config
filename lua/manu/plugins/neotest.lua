return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",

        -- Test runners
        "nvim-neotest/neotest-jest",
        "rouge8/neotest-rust"
    },
    config = function()
        require('neotest').setup({
            adapters = {
                -- Javascript/Typescript adapter.
                require('neotest-jest')({
                    jestCommand = "yarn jest",
                    jestConfigFile = function()
                        local file = vim.fn.expand('%:p')
                        if string.find(file, "/packages/") then
                            return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
                        end

                        return vim.fn.getcwd() .. "/jest.config.ts"
                    end,
                    env = { CI = true },
                    cwd = function()
                        local file = vim.fn.expand('%:p')
                        if string.find(file, "/packages/") then
                            return string.match(file, "(.-/[^/]+/)src")
                        end
                        return vim.fn.getcwd()
                    end
                }),
                -- Rust adapter
                require("neotest-rust") {
                    dap_adapter = "lldb",
                },
            }
        })
    end,
    keys = {
        {
            "<leader>tr",
            function()
                require("neotest").run.run()
            end,
            desc = "Run nearest test"
        },
        {
            "<leader>tR",
            function()
                require("neotest").run.run(vim.fn.expand("%"))
            end,
            desc = "Run all tests in file"
        },
        {
            "<leader>td",
            function()
                require("neotest").run.run({ strategy = "dap" })
            end,
            desc = "Debug nearest test"
        },
        {
            "<leader>to",
            function()
                require("neotest").output_panel.toggle()
            end,
            desc = "Toggle test output"
        },
        {
            "<leader>ts",
            function()
                require("neotest").summary.toggle()
            end,
            desc = "Toggle test summary"
        }
    }
}
