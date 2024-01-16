-- diffview.nvim: to review the file changes.
return {
    'sindrets/diffview.nvim',
    lazy = true,
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    keys = {
        { "<leader>gd", "<cmd>DiffviewOpen<cr>",          mode = "n", desc = "Open diffview" },
        { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", mode = "n", desc = "Open diffview current file history" },
        { "<leader>gH", "<cmd>DiffviewFileHistory<cr>",   mode = "n", desc = "Open diffview branch history" },
        { "<leader>gc", "<cmd>DiffviewClose<cr>",         mode = "n", desc = "Close diffview" },
    }
}
