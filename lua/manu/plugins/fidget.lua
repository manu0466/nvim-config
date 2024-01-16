-- Plugin to display the LSP server informations
return {
    "j-hui/fidget.nvim",
    tag = "v1.2.0",
    event = "VeryLazy",
    opts = {
        -- Options related to LSP progress subsystem
        progress = {
            poll_rate = 0,                -- How and when to poll for progress messages
            suppress_on_insert = false,   -- Suppress new messages while in insert mode
            ignore_done_already = false,  -- Ignore new tasks that are already complete
            ignore_empty_message = false, -- Ignore new tasks that don't contain a message
            clear_on_detach =             -- Clear notification group when LSP server detaches
                function(client_id)
                    local client = vim.lsp.get_client_by_id(client_id)
                    return client and client.name or nil
                end,
            notification_group = -- How to get a progress message's notification group key
                function(msg) return msg.lsp_client.name end,
            ignore = {},         -- List of LSP servers to ignore

            -- Options related to how LSP progress messages are displayed as notifications
            display = {
                render_limit = 16, -- How many LSP messages to show at once
                done_ttl = 1, -- How long a message should persist after completion
                done_icon = "✔", -- Icon shown when all LSP progress tasks are complete
                done_style = "Constant", -- Highlight group for completed LSP tasks
                progress_ttl = math.huge, -- How long a message should persist when in progress
                progress_icon = { pattern = "meter", period = 1 },
                progress_style = "WarningMsg",
                group_style = "Title",   -- Highlight group for group name (LSP server name)
                icon_style = "Question", -- Highlight group for group icons
                priority = 30,           -- Ordering priority for LSP notification group
                skip_history = true,     -- Whether progress notifications should be omitted from history
                format_annote =          -- How to format a progress annotation
                    function(msg) return msg.title end,
                format_group_name =      -- How to format a progress notification group's name
                    function(group) return tostring(group) end,
            },

            -- Options related to Neovim's built-in LSP client
            lsp = {
                progress_ringbuf_size = 0, -- Configure the nvim's LSP progress ring buffer size
            },
        },

        -- Options related to integrating with other plugins
        integration = {
            ["nvim-tree"] = {
                enable = true, -- Integrate with nvim-tree/nvim-tree.lua (if installed)
            },
        },
    },
}
