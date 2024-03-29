local M = {}

local utils = require("playground.utils")


--- @class SelectorOptions
--- @field file_options string[] [filename, creation time, playground path]
--- @field title? string


--- Either use builtin selector or telescope if available
--- @param opts SelectorOptions
--- @param tel_func function
--- @param default_func function
function M.selector(opts, tel_func, default_func)
    local config = require("playground.config").options
    opts.title = opts.title or "Select"
    if config.telescope and package.loaded["telescope"] then
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local conf = require("telescope.config").values

        local actions = require "telescope.actions"
        local action_state = require "telescope.actions.state"

        pickers.new({}, {
            prompt_title = opts.title,
            finder = finders.new_table {
                results = opts.file_options or {},
                entry_maker = function(entry)
                    return {
                        value = entry,
                        display = entry[1],
                        ordinal = entry[1],
                        path = utils.get_existing_playground_config(entry[3]).file_path,
                    }
                end
            },
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(prompt_bufnr, _)
                actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local selection = action_state.get_selected_entry()
                    if selection then
                        tel_func(selection)
                        -- local value = selection.value
                        -- open_playground({ path = value[3] })
                        return
                    end
                    -- TODO handle if name is a new file name: action_state.get_current_line()
                end)
                return true
            end,
        }):find()
        return
    end

    vim.ui.select(
        opts.file_options,
        {
            prompt = opts.title,
            format_item = function(item)
                return item[1]
            end
        },
        function(choice)
            if not choice then
                return
            end
            default_func(choice)
        end
    )
end

--- Do a live grep search on files inside the playgrounds
--- @param root_dir string
function M.live_grep(root_dir)
    local has_telescope, telescope_builtin = pcall(require, "telescope.builtin")
    if not has_telescope then
        vim.notify("Playground search requires telescope to work", "ERROR")
        return
    end
    telescope_builtin.live_grep(
        { cwd = root_dir }
    )
end

return M
