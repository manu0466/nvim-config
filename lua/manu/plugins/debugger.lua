local function get_bin_path(bin)
    local output = vim.fn.system(('whereis %s | cut -d " " -f 2'):format(bin))
    local bin_path, _ = string.gsub(output, "\n", "")
    return bin_path
end

return {
    'mfussenegger/nvim-dap',
    dependencies = {
        'rcarriga/nvim-dap-ui',
    },
    config = function()
        local dap, dapui = require("dap"), require("dapui")
        dapui.setup({
            layouts = { {
                elements = { {
                    id = "scopes",
                    size = 0.25
                }, {
                    id = "breakpoints",
                    size = 0.25
                }, {
                    id = "stacks",
                    size = 0.25
                }, {
                    id = "watches",
                    size = 0.25
                } },
                position = "right",
                size = 40
            }, {
                elements = { {
                    id = "repl",
                    size = 0.5
                }, {
                    id = "console",
                    size = 0.5
                } },
                position = "bottom",
                size = 10
            } },
        })

        -- nvim-dap-ui integration
        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        -- Javascript/Typescript Node
        dap.adapters["pwa-node"] = {
            type = "server",
            host = "localhost",
            port = "${port}",
            executable = {
                command = get_bin_path('js-debug-adapter'),
                args = { "${port}" },
            }
        }
        dap.configurations.javascript = {
            {
                type = "pwa-node",
                request = "launch",
                name = "Launch file",
                program = "${file}",
                cwd = "${workspaceFolder}",
            },
        }

        -- C C++ Rust
        dap.adapters.codelldb = {
            type = 'server',
            port = "${port}",
            executable = {
                command = 'codelldb',
                args = { "--port", "${port}" },
            }
        }
        dap.configurations.cpp = {
            {
                name = "Launch file",
                type = "codelldb",
                request = "launch",
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
            },
        }
        dap.configurations.c = dap.configurations.cpp
        dap.configurations.rust = dap.configurations.cpp
    end,
    keys = {
        {
            "<leader>Dc",
            function()
                require('dap').continue()
            end,
            desc = "Debugger Continue"
        },
        {
            "<leader>Dn",
            function()
                require('dap').step_over()
            end,
            desc = "Debugger Step Over"
        },
        {
            "<leader>Dt",
            function()
                require('dap').toggle_breakpoint()
            end,
            desc = "Debugger Toggle Breakpoint"
        },
        {
            "<leader>Dh",
            function()
                require('dap.ui.widgets').hover()
            end,
            desc = "Show variable information"
        }
    }
}
