-- Set 2-space indentation for JS, JSX, TS, TSX files
vim.api.nvim_create_augroup('JsTsIndent', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
    group = 'JsTsIndent',
    pattern = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    callback = function()
        vim.bo.shiftwidth = 2
        vim.bo.tabstop = 2
        vim.bo.expandtab = true
    end,
})
