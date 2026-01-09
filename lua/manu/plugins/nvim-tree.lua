return {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    opts = {
        view = {
            number = true,
            relativenumber = true,
            width = {
                min = 30,
                max = -1,
            }
        }
    },
    keys = {
        { "<C-n>",      "<cmd>NvimTreeToggle<CR>",   desc = "Open nvim-tree" },
        { "<leader>e",  "<cmd>NvimTreeFocus<CR>",    desc = "Focus nvim-tree" },
        { "<leader>fF", "<cmd>NvimTreeFindFile<CR>", desc = "Focus nvim-tree" },
    },
}
