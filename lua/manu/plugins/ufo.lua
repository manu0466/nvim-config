-- nvim-ufo folding plugin
return {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    event = "BufReadPost",
    init = function()
        vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
        vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
    end,
    config = function()
        require('ufo').setup({
            provider_selector = function()
                return { 'treesitter', 'indent' }
            end
        })
    end,
}
