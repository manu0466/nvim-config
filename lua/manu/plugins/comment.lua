-- Comment.nvim to comment blocks of code
return {
    'numToStr/Comment.nvim',
    opts = {
        mappings = {
            ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
            basic = true,
            ---Extra mapping; `gco`, `gcO`, `gcA`
            extra = true,
        },
    },
    lazy = false,
}
