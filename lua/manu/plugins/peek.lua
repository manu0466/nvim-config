-- https://github.com/toppair/peek.nvim
-- Plugin to display Markdown previews.

return {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
        require("peek").setup({
            auto_load = true,
            update_on_change = true,
            app = { 'brave', '--incognito' },
            -- app = 'webview',
            filetype = { 'markdown' },
            theme = 'dark',
        })
        vim.api.nvim_create_user_command("MarkdownPreviewToggle", function()
            local peek = require("peek")
            if not peek.is_open() then
                if vim.bo[vim.api.nvim_get_current_buf()].filetype == 'markdown' then
                    vim.fn.system('i3-msg split horizontal')
                    peek.open()
                end
            else
                peek.close()
                vim.fn.system('i3-msg move left')
            end
        end, {})
        vim.api.nvim_create_user_command("MarkdownPreviewClose", require("peek").close, {})
    end,
    keys = {
        { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Open markdown preview" },
    }
}
