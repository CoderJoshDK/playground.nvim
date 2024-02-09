local M = {}


M.config_file_name = ".playground.nvim.json"

--- Concatenate directories and/or file paths into a single path with normalization
--- (e.g., `"foo/"` and `"bar"` get joined to `"foo/bar"`)
--- Copy pasta from Nvim 0.10 :D
--- @param ... string
--- @return string
function M.joinpath(...)
    return (table.concat({ ... }, '/'):gsub('//+', '/'))
end

--- Load a table from the created config json
--- @param playground_root string
--- @return table
function M.get_existing_playground_config(playground_root)
    local playground_config_file = io.open(M.joinpath(playground_root, M.config_file_name), "r")
    if not playground_config_file then
        error("Required config file could not be opened, to open given playground " .. playground_root)
    end

    --- @type table
    ---@diagnostic disable-next-line: assign-type-mismatch
    local playground_config = vim.fn.json_decode(playground_config_file:read("*a"))
    return playground_config
end

--- Replace `_` with `-`
--- @param path string
--- @return string
function M.clean_filename(path)
    return (path:gsub("_", "-"))
end

--- Check if path is absolute
--- @param path string
--- @return boolean
function M.is_absolute_path(path)
    if path:match("^%a:/") then
        return true
    end

    if path:sub(1, 1) == "/" then
        return true
    end

    return false
end

return M
