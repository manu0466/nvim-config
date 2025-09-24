return {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    config = function()
        require("nvim-tree").setup()
    end,
    keys = {
        { "<C-n>",      "<cmd>NvimTreeToggle<CR>",   desc = "Open nvim-tree" },
        { "<leader>e",  "<cmd>NvimTreeFocus<CR>",    desc = "Focus nvim-tree" },
        { "<leader>fF", "<cmd>NvimTreeFindFile<CR>", desc = "Focus nvim-tree" },
    },
}
