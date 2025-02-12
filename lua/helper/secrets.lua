local M = {}
local secrets_var = {}

function M.get(key, default)
    local value = secrets_var[key] or os.getenv(key)
    return value or default
end

function M.load_secrets(file_path)
    file_path = file_path or os.getenv("HOME") .. "/.config/nvim/.secrets"
    local file, _ = io.open(file_path, "r")
    if not file then
        return
    end

    local content = file:read("*all")
    file:close()

    for line in content:gmatch("[^\r\n]+") do
        local key, value = line:match("^([%w_]+)%s*=%s*(.+)$")
        if key and value then
            value = value:gsub("^[\"'](.-)[\"\']$", "%1")
            secrets_var[key] = value
        end
    end
end

return M
