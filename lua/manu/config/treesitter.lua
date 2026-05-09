vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'lua', 'rust', 'php', 'tex', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'json', 'css' },
    callback = function()
        -- syntax highlighting, provided by Neovim
        vim.treesitter.start()
    end,
})
