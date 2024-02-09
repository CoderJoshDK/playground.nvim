--- Create temporary playgrounds for testing ideas!
--- A simple scratch file plugin, that integrates well with your other plugins (LSPs/CMP)
---
--- Inspired by: https://github.com/LintaoAmons/scratch.nvim

local scratch = require("playground.scratch")

---@class Playground
local M = {}

--- @param opts? {}
function M.setup(opts)
    opts = opts or {}
    require("playground.config").setup(opts)

    -- Setup user commands
    require("playground.commands").setup()
end

--- Create a scratch file and needed work space
--- @param opts? table
function M.create_playground(opts)
    -- TODO create system for making cwd the created directory.
    -- Would need to do something similar to zen-mode
    -- https://github.com/folke/zen-mode.nvim/blob/78557d972b4bfbb7488e17b5703d25164ae64e6a/lua/zen-mode/view.lua#L199

    opts = opts or {}
    -- TODO replace with `view.lua`

    if not opts.ft or opts.ft == "" then
        vim.ui.input({ prompt = "Enter file type extension: " }, function(input)
            if not input then
                vim.notify("Canceled playground creation")
                opts.ft = nil
            else
                opts.ft = vim.trim(input)
            end
        end)
    end
    if not opts.ft then
        return
    end
    scratch.open_playground(opts)
end

function M.select_playground()
    scratch.select_playground()
end

function M.search_playgrounds()
    scratch.search_playgrounds()
end

--- Cleanup the cache directory, by deleting old files.
--- Old is defined by in `setup({ cleanup_age = boolean })`.
--- @param force? boolean
function M.cleanup(force)
    scratch.delete_old_playgrounds(force or false)
end

vim.api.nvim_create_autocmd({ "VimLeave" }, {
    callback = function()
        M.cleanup()
    end,
})

return M
