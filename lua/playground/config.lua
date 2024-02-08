--- @class Config
local M = {}

local joinpath = require("playground.utils").joinpath

--- @class PlaygroundOptions
M.defaults = {
    -- Aboslute path to where playgrounds are created and managed
    -- The given example path is for MacOS, but the correct OS path will be used
    -- WARNING Must be an absolute path
    root_dir = joinpath(vim.fn.stdpath("cache"), "playground.nvim"),
    -- When no `ft` is given to `scratch.open_playground`, use the following default extension
    default_ft = "txt",
    -- hours_to_live can be:
    -- * -1 : never delete files (unless `:PlaygroundDeleteAll` is ran)
    -- * n  : delete all playgrounds on `VimLeave`, after `n` hours since playground creation
    hours_to_live = -1,
    -- Add any file type extension that you want custom settings for
    ft = {
        txt = {
            -- lines of text to add to the top of the file
            lines = { "Quick Notes", os.date("%Y-%m-%d-%H:%M:%S") }
        }
        -- example of a python setup. But not set as a default
        -- py = {
        --     lines = { "import numpy", "print('hi')" }
        -- }
    },
    telescope = true, -- weather or not to use telescope (if available)
}

--- @type PlaygroundOptions
M.options = {}

--- @param opts? table
function M.setup(opts)
    M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})
    M._init_cache()
end

function M._init_cache()
    if vim.fn.mkdir(M.options.root_dir, "p") == 0 then
        error("Failed to create playground directory")
    end
end

M.setup()

return M
