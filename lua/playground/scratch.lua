-- local options = require("playground.config").options
local joinpath = require("playground.utils").joinpath

local M = {}
local config_file_name = ".playground.nvim.json"

--- Open a playground. If one does not exist based on given options, create one
--- @param opts table
function M.open_playground(opts)
    if opts.path then
        local playground_config_file = io.open(joinpath(opts.path, config_file_name), "r")
        if not playground_config_file then
            error("Required config file could not be opened, to open given playground " .. opts.path)
        end

        --- @type table
        ---@diagnostic disable-next-line: assign-type-mismatch
        local playground_config = vim.fn.json_decode(playground_config_file:read("*a"))

        local buf_n
        -- Make sure buffer name isn't already open, and if it is, just use that buffer
        local already_open = false
        for _, buf in pairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_get_name(buf) == playground_config.file_path then
                already_open = true
                buf_n = buf
                break
            end
        end
        if not already_open then
            vim.api.nvim_command("edit " .. playground_config.file_path)
            -- buf_n = vim.api.nvim_get_current_buf()
        else
            vim.api.nvim_set_current_buf(buf_n)
            vim.cmd.filetype("detect")
        end

        return
    end


    local buf_n = M._create_workspace(opts.ft, opts.name)
    vim.api.nvim_set_current_buf(buf_n)
    vim.cmd.filetype("detect")
end

--- Delete all playgrounds that are older than `hours_to_live` unless `-1`
--- @param force? boolean forcefully delete all playgrounds, regardless of `Config.hours_to_live`
function M.delete_old_playgrounds(force)
    local options = require("playground.config").options
    local files = vim.fn.readdir(options.root_dir)

    local current_time = os.time() - (60 * 60 * options.hours_to_live)
    local time = os.date("%Y-%m-%d-%H:%M:%S", current_time)

    for _, file in ipairs(files) do
        local creation_time, _ = unpack(vim.split(file, "_"))

        -- Only delete old playgrounds
        if (options.hours_to_live ~= -1 and creation_time < time) or force then
            vim.fn.delete(joinpath(options.root_dir, file), "rf")
        end
    end
end

function M.select_playground()
    local options = require("playground.config").options
    local files = vim.fn.readdir(options.root_dir)


    local file_options = {}

    for _, file in ipairs(files) do
        local creation_time, filename = unpack(vim.split(file, "_"))
        table.insert(file_options, { filename, creation_time, joinpath(options.root_dir, file) })
    end

    -- TODO abstract into `view.lua`
    vim.ui.select(
        file_options,
        {
            prompt = "Select playground to open: ",
            format_item = function(item)
                return item[1]
            end
        },
        function(choice)
            if not choice then
                return
            end
            M.open_playground({ path = choice[3], filename = choice[1] })
        end
    )
end

--- Create the path required for files
--- @param name string custom name of scratch file
--- @param time string|osdate string time of path creation
--- @return string filepath
function M._create_path(name, time)
    local options = require("playground.config").options

    -- TODO replace all `_` with `-` in filename
    local filename = name
    local folder_name = time .. "_" .. filename
    local file_path = joinpath(options.root_dir, folder_name)

    if vim.fn.mkdir(file_path, "p") == 0 then
        error("Could not create temp folder")
    end

    return file_path
end

--- @param ft? string File extension (default found in config)
--- @param name? string Name of the workspace (playground)
--- @return integer BuffNumber Number of created buffer
function M._create_workspace(ft, name)
    local options = require("playground.config").options
    ft = ft or options.default_ft
    if ft == "" then
        ft = options.default_ft
    end

    local time = os.date("%Y-%m-%d-%H:%M:%S")
    local filename = tostring(name or time)
    local folder_path = M._create_path(filename, time)
    local file_path = joinpath(folder_path, filename .. "." .. ft)

    local file_options = options.ft[ft] or { lines = {} }
    file_options.file_path = file_path
    -- create required workspace setup
    local settings_file = io.open(joinpath(folder_path, config_file_name), "w")
    if not settings_file then
        error("Could not construct workspace settings file")
    end

    -- TODO add more things into the json
    -- This will let me have custom build steps and other related information

    settings_file:write(vim.fn.json_encode(file_options))
    settings_file:close()

    local buf_n = vim.api.nvim_create_buf(false, false)
    if buf_n == 0 then
        error("Error creating new buffer (`vim.api.nvim_create_buf(true, false)`)")
    end

    vim.api.nvim_buf_set_lines(buf_n, 0, 0, false, file_options.lines)
    vim.api.nvim_buf_set_name(buf_n, file_path)
    return buf_n
end

return M
