return {
    "nvim-telescope/telescope.nvim",
    tag = 'v0.2.1',
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-media-files.nvim",
        "nvim-lua/popup.nvim"
    },
    cmd = "Telescope",
    config = function()
        local telescope = require("telescope")
        telescope.setup({
            defaults = {
                vimgrep_arguments = {
                    "rg",
                    "-L",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                },
                prompt_prefix = "   ",
                selection_caret = "  ",
                entry_prefix = "  ",
                initial_mode = "insert",
                selection_strategy = "reset",
                sorting_strategy = "ascending",
                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = {
                        prompt_position = "top",
                        preview_width = 0.55,
                        results_width = 0.8,
                    },
                    vertical = {
                        mirror = false,
                    },
                    width = 0.87,
                    height = 0.80,
                    preview_cutoff = 120,
                },
                file_sorter = require("telescope.sorters").get_fuzzy_file,
                file_ignore_patterns = { "node_modules" },
                generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
                path_display = { "truncate" },
                winblend = 0,
                border = {},
                borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                color_devicons = true,
                set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
                file_previewer = require("telescope.previewers").vim_buffer_cat.new,
                grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
                qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
                -- Developer configurations: Not meant for general override
                buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
                mappings = {
                    i = { ["<C-h>"] = "which_key" },
                    n = { ["q"] = require("telescope.actions").close },
                },
            },
            extensions = {
                media_files = {
                    -- filetypes whitelist
                    -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
                    filetypes = { "png", "webp", "jpg", "jpeg" },
                    -- find command (defaults to `fd`)
                    find_cmd = "rg"
                }
            },
        })
        telescope.load_extension("media_files")
    end,
    keys = {
        { "<leader>fg", "<cmd>Telescope git_files<cr>",  desc = "Find file in git repo" },
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find file" },
        {
            "<leader>fb",
            function()
                require("telescope.builtin").current_buffer_fuzzy_find()
            end,
            desc = "Fuzy find in current buffer",
        },
        { "<leader>fw", "<cmd>Telescope live_grep<cr>",   desc = "Live grep find" },
        { "<leader>fm", "<cmd>Telescope media_files<cr>", desc = "Find media files" },
    },
}
