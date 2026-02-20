return {
    'saghen/blink.cmp',
    dependencies = {
        'rafamadriz/friendly-snippets',
        {
            'supermaven-inc/supermaven-nvim',
            opts = {
                disable_inline_completion = true,
                disable_keymaps = true,
                -- Disbable log for having inline completion without cmp
                log_level = "off"
            },
        },
        'huijiro/blink-cmp-supermaven'
    },
    version = '1.*',
    opts = {
        keymap = { preset = 'enter' },
        appearance = {
            -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = 'mono',
        },
        -- (Default) Only show the documentation popup when manually triggered
        completion = {
            documentation = { auto_show = true },
            menu = {
                auto_show = true,
                draw = {
                    columns = {
                        { "label", "label_description", gap = 1 },
                        { "kind",  gap = 1,             "source_name" } },
                },
            },
        },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
            providers = {
                supermaven = {
                    name = 'supermaven',
                    module = "blink-cmp-supermaven",
                    async = true
                },
            },
            default = { 'supermaven', 'lsp', 'path', 'snippets', 'buffer' },
            per_filetype = {
                DressingInput = {}, -- disable autocomplete for NvimTree
            },
        },

        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
}
