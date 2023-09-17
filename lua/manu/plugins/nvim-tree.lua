return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        {
            -- File name rename and refactoring
            "manu0466/nvim-lsp-file-operations",
            dependencies = {
                "nvim-lua/plenary.nvim",
            }
        },
    },
    lazy = false,
    config = function()
        require("nvim-tree").setup({
            on_attach = "default",
            hijack_cursor = false,
            auto_reload_on_write = true,
            disable_netrw = true,
            hijack_netrw = true,
            hijack_unnamed_buffer_when_opening = true,
            root_dirs = {},
            prefer_startup_root = false,
            sync_root_with_cwd = false,
            reload_on_bufenter = false,
            respect_buf_cwd = false,
            select_prompts = false,
            sort = {
                sorter = "name",
                folders_first = true,
                files_first = false,
            },
            view = {
                centralize_selection = false,
                cursorline = true,
                debounce_delay = 15,
                hide_root_folder = false,
                side = "left",
                preserve_window_proportions = false,
                number = false,
                relativenumber = false,
                signcolumn = "yes",
                width = {
                    min = 30,
                    max = -1,
                    padding = 1,
                },
                float = {
                    enable = false,
                    quit_on_focus_loss = true,
                    open_win_config = {
                        relative = "editor",
                        border = "rounded",
                        width = 30,
                        height = 30,
                        row = 1,
                        col = 1,
                    },
                },
            },
            renderer = {
                add_trailing = false,
                group_empty = false,
                full_name = false,
                root_folder_label = ":~:s?$?/..?",
                indent_width = 2,
                special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md", "package.json" },
                symlink_destination = true,
                highlight_git = true,
                highlight_diagnostics = true,
                highlight_opened_files = "none",
                highlight_modified = "icon",
                indent_markers = {
                    enable = false,
                    inline_arrows = true,
                    icons = {
                        corner = "└",
                        edge = "│",
                        item = "│",
                        bottom = "─",
                        none = " ",
                    },
                },
                icons = {
                    web_devicons = {
                        file = {
                            enable = true,
                            color = true,
                        },
                        folder = {
                            enable = true,
                            color = true,
                        },
                    },
                    git_placement = "before",
                    diagnostics_placement = "signcolumn",
                    modified_placement = "after",
                    padding = " ",
                    symlink_arrow = " ➛ ",
                    show = {
                        file = true,
                        folder = true,
                        folder_arrow = true,
                        git = true,
                        diagnostics = true,
                        modified = true,
                    },
                    glyphs = {
                        default = "",
                        symlink = "",
                        bookmark = "󰆤",
                        modified = "●",
                        folder = {
                            arrow_closed = "",
                            arrow_open = "",
                            default = "",
                            open = "",
                            empty = "",
                            empty_open = "",
                            symlink = "",
                            symlink_open = "",
                        },
                        git = {
                            unstaged = "✗",
                            staged = "✓",
                            unmerged = "",
                            renamed = "➜",
                            untracked = "★",
                            deleted = "",
                            ignored = "◌",
                        },
                    },
                },
            },
            hijack_directories = {
                enable = true,
                auto_open = true,
            },
            update_focused_file = {
                enable = true,
                update_root = false,
                ignore_list = {},
            },
            system_open = {
                cmd = "",
                args = {},
            },
            git = {
                enable = true,
                show_on_dirs = true,
                show_on_open_dirs = true,
                disable_for_dirs = {},
                timeout = 400,
            },
            diagnostics = {
                enable = true,
                show_on_dirs = true,
                show_on_open_dirs = true,
                debounce_delay = 50,
                severity = {
                    min = vim.diagnostic.severity.HINT,
                    max = vim.diagnostic.severity.ERROR,
                },
                icons = {
                    hint = "",
                    info = "",
                    warning = "",
                    error = "",
                },
            },
            modified = {
                enable = true,
                show_on_dirs = true,
                show_on_open_dirs = true,
            },
            filters = {
                git_ignored = true,
                dotfiles = false,
                git_clean = false,
                no_buffer = false,
                custom = { "node_modules", "\\.git$" },
                exclude = {},
            },
            live_filter = {
                prefix = "[FILTER]: ",
                always_show_folders = true,
            },
            filesystem_watchers = {
                enable = true,
                debounce_delay = 50,
                ignore_dirs = {},
            },
            actions = {
                use_system_clipboard = true,
                change_dir = {
                    enable = true,
                    global = false,
                    restrict_above_cwd = false,
                },
                expand_all = {
                    max_folder_discovery = 300,
                    exclude = {},
                },
                file_popup = {
                    open_win_config = {
                        col = 1,
                        row = 1,
                        relative = "cursor",
                        border = "shadow",
                        style = "minimal",
                    },
                },
                open_file = {
                    quit_on_open = false,
                    eject = true,
                    resize_window = true,
                    window_picker = {
                        enable = true,
                        picker = "default",
                        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
                        exclude = {
                            filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                            buftype = { "nofile", "terminal", "help" },
                        },
                    },
                },
                remove_file = {
                    close_window = true,
                },
            },
            trash = {
                cmd = "gio trash",
            },
            tab = {
                sync = {
                    open = false,
                    close = false,
                    ignore = {},
                },
            },
            notify = {
                threshold = vim.log.levels.INFO,
                absolute_path = true,
            },
            ui = {
                confirm = {
                    remove = true,
                    trash = true,
                },
            },
            experimental = {},
            log = {
                enable = false,
                truncate = false,
                types = {
                    all = false,
                    config = false,
                    copy_paste = false,
                    dev = false,
                    diagnostics = false,
                    git = false,
                    profile = false,
                    watcher = false,
                },
            },
        })

        require("lsp-file-operations").setup({
            -- debug = true,
            recursive_rename = true,
            autosave = true,
        })
    end,
    keys = {
        { "<C-n>",     "<cmd>NvimTreeToggle<CR>", desc = "Open nvim-tree" },
        { "<leader>e", "<cmd>NvimTreeFocus<CR>",  desc = "Focus nvim-tree" },
    },
}
