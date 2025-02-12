-- Custom Parameters (with defaults)
return {
    "David-Kunz/gen.nvim",
    lazy = false,
    opts = {
        model = "mistral:7b",   -- The default model to use.
        quit_map = "q",         -- set keymap to close the response window
        retry_map = "<c-r>",    -- set keymap to re-send the current prompt
        accept_map = "<c-cr>",  -- set keymap to replace the previous selection with the last result
        display_mode = "float", -- The display mode. Can be "float" or "split" or "horizontal-split".
        show_prompt = false,    -- Shows the prompt submitted to Ollama. Can be true (3 lines) or "full".
        show_model = true,      -- Displays which model you are using at the beginning of your chat session.
        no_auto_close = false,  -- Never closes the window automatically.
        file = false,           -- Write the payload to a temporary file to keep the command short.
        hidden = false,         -- Hide the generation window (if true, will implicitly set `prompt.replace = true`), requires Neovim >= 0.10
        init = function(options) end,
        command = function(options)
            return "curl -u " ..
                options.user .. ":" .. options.password .. " -q --silent --no-buffer -X POST " ..
                options.url .. "/api/chat -d $body"
        end,
        list_models = function(options)
            local response = vim.fn.systemlist(
                "curl -u " ..
                options.user .. ":" .. options.password .. " -q --silent --no-buffer " .. options.url .. "/api/tags")
            local list = vim.fn.json_decode(response)
            local models = {}
            for key, _ in pairs(list.models) do
                table.insert(models, list.models[key].name)
            end
            table.sort(models)
            return models
        end,
        result_filetype = "markdown", -- Configure filetype of the result buffer
        debug = false                 -- Prints errors and the command which is run.
    },
    config = function(plugin, opts)
        local secrets = require("helper.secrets")
        opts.url = secrets.get("OLLAMA_URL")
        opts.user = secrets.get("OLLAMA_USER")
        opts.password = secrets.get("OLLAMA_PASSWORD")
        require("gen").setup(opts)
    end,
    keys = {
        { "<leader>lgr", "<cmd>Gen Enhance_Grammar_Spelling<cr>", desc = "Enhance Grammar & Spelling", mode = { "n", "v" } },
    },
}
