return {
    'akinsho/bufferline.nvim',
    -- version = "*",
    branch = 'main',
    dependencies = 'nvim-tree/nvim-web-devicons',
    lazy = false,
    config = function()
        local bufferline = require("bufferline")
        bufferline.setup({
            options = {
                -- Style
                separator_style = "slant",
                style_preset = {
                    bufferline.style_preset.no_italic,
                },
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "File Explorer",
                        text_align = "center",
                        separator = true,
                    },
                    {
                        filetype = "undotree",
                        text = "Undo Tree",
                        text_align = "left",
                        separator = true
                    }
                },
                -- Diagnostics
                diagnostics = "nvim_lsp",
                --- count is an integer representing total count of errors
                --- level is a string "error" | "warning"
                --- this should return a string
                --- Don't get too fancy as this function will be executed a lot
                diagnostics_indicator = function(count, level)
                    local icon = level:match("error") and " " or ""
                    return icon .. " " .. count
                end,
            },
        })
    end,
    keys = {
        { "<A-Left>",    "<cmd>BufferLineCyclePrev<cr>", desc = "BufferLine go to previous" },
        { "<A-h>",       "<cmd>BufferLineCyclePrev<cr>", desc = "BufferLine go to previous" },
        { "<A-Right>",   "<cmd>BufferLineCycleNext<cr>", desc = "BufferLine go to next" },
        { "<A-l>",       "<cmd>BufferLineCycleNext<cr>", desc = "BufferLine go to next" },
        { "<S-A-Left>",  "<cmd>BufferLineMovePrev<cr>",  desc = "BufferLine move to previous" },
        { "<S-A-Right>", "<cmd>BufferLineMoveNext<cr>",  desc = "BufferLine move to next" },
        {
            "<A-x>",
            function()
                -- Save the current buffer number
                local current_buffer = vim.fn.bufnr('%')
                -- Move to the previous buffer
                vim.cmd('BufferLineCyclePrev')
                -- Close the previous buffer
                vim.cmd("bd " .. current_buffer)
            end,
            desc = "Close buffer"
        },
    }
}
