---@type vim.lsp.Config
return {
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
                    "--lib",
                    "--message-format=json",
                }
            }
        },
    },

}
