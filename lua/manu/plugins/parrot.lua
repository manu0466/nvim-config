return {
    "frankroeder/parrot.nvim",
    lazy = false,
    dependencies = { 'nvim-lua/plenary.nvim' },
    -- optionally include "folke/noice.nvim" or "rcarriga/nvim-notify" for beautiful notifications
    config = function()
        local secrets = require("helper.secrets")
        local protocol = secrets.get("OLLAMA_PROTOCOL")
        local host = secrets.get("OLLAMA_HOST")
        local user = secrets.get("OLLAMA_USER")
        local password = secrets.get("OLLAMA_PASSWORD")

        require("parrot").setup {
            -- Providers must be explicitly set up to make them available.
            providers = {
                ollama = {
                    name = "ollama",
                    endpoint = protocol .. "://" .. user .. ":" .. password .. "@" .. host .. "/api/chat",
                    api_key = "", -- not required for local Ollama
                    params = {
                        chat = { temperature = 1.5, top_p = 1, num_ctx = 8192, min_p = 0.05 },
                        command = { temperature = 1.5, top_p = 1, num_ctx = 8192, min_p = 0.05 },
                    },
                    topic_prompt = [[
    Summarize the chat above and only provide a short headline of 2 to 3
    words without any opening phrase like "Sure, here is the summary",
    "Sure! Here's a shortheadline summarizing the chat" or anything similar.
    ]],
                    topic = {
                        model = "mistral:7b",
                        params = { max_tokens = 32 },
                    },
                    headers = {
                        ["Content-Type"] = "application/json",
                    },
                    models = {
                        "deepseek-coder:6.7b",
                        "mistral:7b",
                    },
                    resolve_api_key = function()
                        return true
                    end,
                    process_stdout = function(response)
                        if response:match "message" and response:match "content" then
                            local ok, data = pcall(vim.json.decode, response)
                            if ok and data.message and data.message.content then
                                return data.message.content
                            end
                        end
                    end,
                    get_available_models = function(self)
                        local url = self.endpoint:gsub("chat", "")
                        local logger = require "parrot.logger"
                        local job = Job:new({
                            command = "curl",
                            args = { "-H", "Content-Type: application/json", url .. "tags" },
                        }):sync()
                        local parsed_response = require("parrot.utils").parse_raw_response(job)
                        self:process_onexit(parsed_response)
                        if parsed_response == "" then
                            logger.debug("Ollama server not running on " .. endpoint_api)
                            return {}
                        end

                        local success, parsed_data = pcall(vim.json.decode, parsed_response)
                        if not success then
                            logger.error("Ollama - Error parsing JSON: " .. vim.inspect(parsed_data))
                            return {}
                        end

                        if not parsed_data.models then
                            logger.error "Ollama - No models found. Please use 'ollama pull' to download one."
                            return {}
                        end

                        local names = {}
                        for _, model in ipairs(parsed_data.models) do
                            table.insert(names, model.name)
                        end

                        return names
                    end,
                },
                pplx = {
                    name = "pplx",
                    api_key = secrets.get("PPLX_API_KEY"),
                    endpoint = "https://api.perplexity.ai/chat/completions",
                    params = {
                        chat = { temperature = 1.1, top_p = 1 },
                        command = { temperature = 1.1, top_p = 1 },
                    },
                    topic = {
                        model = "sonar",
                        params = { max_tokens = 64 },
                    },
                    models = {
                        "sonar",
                        "sonar-pro",
                        "sonar-reasoning",
                        "sonar-reasoning-pro",
                        "sonar-deep-research",
                        "r1-1776",
                    },
                },
                gemini = {
                    name = "gemini",
                    endpoint = function(self)
                        return "https://generativelanguage.googleapis.com/v1beta/models/"
                            .. self._model
                            .. ":streamGenerateContent?alt=sse"
                    end,
                    model_endpoint = function(self)
                        return { "https://generativelanguage.googleapis.com/v1beta/models?key=" .. self.api_key }
                    end,
                    api_key = secrets.get("GEMINI_API_KEY"),
                    params = {
                        chat = { temperature = 1.1, topP = 1, topK = 10, maxOutputTokens = 8192 },
                        command = { temperature = 0.8, topP = 1, topK = 10, maxOutputTokens = 8192 },
                    },
                    topic = {
                        model = "gemini-1.5-flash",
                        params = { maxOutputTokens = 64 },
                    },
                    headers = function(self)
                        return {
                            ["Content-Type"] = "application/json",
                            ["x-goog-api-key"] = self.api_key,
                        }
                    end,
                    models = {
                        "gemini-2.5-flash-preview-05-20",
                        "gemini-2.0-flash",
                        "gemini-2.0-flash-lite",
                        "gemini-1.5-flash",
                        "gemini-1.5-flash-8b",
                    },
                    preprocess_payload = function(payload)
                        local contents = {}
                        local system_instruction = nil
                        for _, message in ipairs(payload.messages) do
                            if message.role == "system" then
                                system_instruction = { parts = { { text = message.content } } }
                            else
                                local role = message.role == "assistant" and "model" or "user"
                                table.insert(
                                    contents,
                                    { role = role, parts = { { text = message.content:gsub("^%s*(.-)%s*$", "%1") } } }
                                )
                            end
                        end
                        local gemini_payload = {
                            contents = contents,
                            generationConfig = {
                                temperature = payload.temperature,
                                topP = payload.topP or payload.top_p,
                                maxOutputTokens = payload.max_tokens or payload.maxOutputTokens,
                            },
                        }
                        if system_instruction then
                            gemini_payload.systemInstruction = system_instruction
                        end
                        return gemini_payload
                    end,
                    process_stdout = function(response)
                        if not response or response == "" then
                            return nil
                        end
                        local success, decoded = pcall(vim.json.decode, response)
                        if
                            success
                            and decoded.candidates
                            and decoded.candidates[1]
                            and decoded.candidates[1].content
                            and decoded.candidates[1].content.parts
                            and decoded.candidates[1].content.parts[1]
                        then
                            return decoded.candidates[1].content.parts[1].text
                        end
                        return nil
                    end,
                },
            },
            cmd_prefix = "Prt",
            chat_conceal_model_params = false,
            user_input_ui = "buffer",
            toggle_target = "",
            online_model_selection = true,
            command_auto_select_response = true,
            show_context_hints = true,
            per_symbol_delay = 20,
            hooks = {
                SpellCheck = function(prt, params)
                    local chat_prompt = [[
        Your task is to take the text provided and rewrite it into a clear,
        grammatically correct version while preserving the original meaning
        as closely as possible. Correct any spelling mistakes, punctuation
        errors, verb tense issues, word choice problems, and other
        grammatical mistakes.
        ]]
                    prt.ChatNew(params, chat_prompt)
                end,
            }
        }
    end,
}
