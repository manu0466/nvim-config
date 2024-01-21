return {
    "doums/darcula",
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
        -- load the color scheme here
        vim.cmd("colorscheme darcula")

        -- Some fix for the theme.
        -- You can use TSHighlightCapturesUnderCursor to find the tag.
        vim.api.nvim_set_hl(0, "SpellBad", { undercurl = true, sp = "#659C6B" })
        vim.api.nvim_set_hl(0, "Todo", { fg = "#A8C023" })
        vim.api.nvim_set_hl(0, "@comment.documentation", { fg = "#629755" })
        vim.api.nvim_set_hl(0, "@include", { fg = "#CC7832" })
        vim.api.nvim_set_hl(0, "Boolean", { fg = "#CC7832" })
        vim.api.nvim_set_hl(0, "@label", { fg = "#9876AA" })

        vim.api.nvim_set_hl(0, "@tag.tsx", { fg = "#26BDA4" })
        vim.api.nvim_set_hl(0, "@constructor.tsx", { fg = "#26BDA4" })
        vim.api.nvim_set_hl(0, "@constructor", { fg = "#CC7832" })
        vim.api.nvim_set_hl(0, "@tag.delimiter", { fg = "#E8BF6A" })
        vim.api.nvim_set_hl(0, "@punctuation.bracket", { fg = "#B9BCD1" })
        vim.api.nvim_set_hl(0, "@operator", { fg = "#B9BCD1" })
        vim.api.nvim_set_hl(0, "@tag.attribute", { fg = "#B9BCD1" })
        vim.api.nvim_set_hl(0, "@punctuation.delimiter", { fg = "#CC7832" })
        vim.api.nvim_set_hl(0, "@constant.builtin", { fg = "#CC7832" })
        vim.api.nvim_set_hl(0, "@variable.builtin", { fg = "#CC7832" })
    end,
}
