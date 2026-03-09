-- https://github.com/ThePrimeagen/99
return {
    "ThePrimeagen/99",
    event = "VeryLazy",
    config = function()
        local _99 = require("99")
        local cwd = vim.uv.cwd()
        local basename = vim.fs.basename(cwd)
        _99.setup({
            provider = _99.Providers.OpenCodeProvider,
            model = "zai-coding-plan/glm-4.7",
            logger = {
                level = _99.DEBUG,
                path = "/tmp/" .. basename .. ".99.debug",
                print_on_error = true,
            },
            -- When setting this to something that is not inside the CWD tools
            -- such as claude code or opencode will have permission issues
            -- and generation will fail refer to tool documentation to resolve
            -- https://opencode.ai/docs/permissions/#external-directories
            -- https://code.claude.com/docs/en/permissions#read-and-edit
            tmp_dir = "./.99",

            --- Completions: #rules and @files in the prompt buffer
            completion = {
                -- I am going to disable these until i understand the
                -- problem better.  Inside of cursor rules there is also
                -- application rules, which means i need to apply these
                -- differently
                -- cursor_rules = "<custom path to cursor rules>"

                --- A list of folders where you have your own SKILL.md
                --- Expected format:
                --- /path/to/dir/<skill_name>/SKILL.md
                ---
                --- Example:
                --- Input Path:
                --- "scratch/custom_rules/"
                ---
                --- Output Rules:
                --- {path = "scratch/custom_rules/vim/SKILL.md", name = "vim"},
                --- ... the other rules in that dir ...
                ---
                custom_rules = {
                    -- "scratch/custom_rules/",
                },

                --- Configure @file completion (all fields optional, sensible defaults)
                files = {
                    enabled = true,
                    max_file_size = 102400, -- bytes, skip files larger than this
                    max_files = 5000,       -- cap on total discovered files
                    exclude = { ".env", ".env.*", "node_modules", ".git" },
                },
                source = "blink", -- "native" (default), "cmp", or "blink"
            },
            md_files = {
                "AGENT.md",
            },
        })
    end,
    keys = function()
        local _99 = require("99")
        local _99_telescope = require("99.extensions.telescope")
        return {
            {
                "<leader>9v",
                function()
                    _99.visual({
                        addition_prompt = [[
                      always add a comment at begining and end of the code
                    ]]
                    })
                end,
                mode = "v",
                desc = "99 Visual"
            },
            {
                "<leader>9x",
                function() _99.stop_all_requests() end,
                mode = "n",
                desc = "99 cancel all requests"
            },
            {
                "<leader>9s",
                function() _99.search() end,
                mode = "n",
                desc = "99 search"
            },
            {
                "<leader>9m",
                function() _99_telescope.select_model() end,
                mode = "n",
                desc = "99 select model"
            },
            {
                "<leader>9l",
                function() _99.view_logs() end,
                mode = "n",
                desc = "99 show logs"
            },
            {
                "<leader>9V",
                function() _99.vibe() end,
                mode = "n",
                desc = "99 vibe mode"
            },
        }
    end
}
