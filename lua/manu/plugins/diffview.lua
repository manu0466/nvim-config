-- diffview.nvim: to review the file changes.
return {
    'sindrets/diffview.nvim',
    lazy = true,
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    init = function()
        vim.opt.fillchars:append { diff = "╱" }
    end,
    keys = {
        { "<leader>gd", "<cmd>DiffviewOpen<cr>",                     mode = "n", desc = "Open diffview" },
        { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>",            mode = "n", desc = "Open diffview current file history" },
        { "<leader>gH", "<cmd>DiffviewFileHistory<cr>",              mode = "n", desc = "Open diffview branch history" },
        { "<leader>gm", "<cmd>:DiffviewOpen origin/main...HEAD<cr>", mode = "n", desc = "diffview HEAD with origin/main" },
        { "<leader>gc", "<cmd>DiffviewClose<cr>",                    mode = "n", desc = "Close diffview" },
    }
}
