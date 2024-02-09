local playground = require("playground")

local M = {}

local CMDS = {
    {
        name = "Playground",
        opts = {
            desc = "playground: create",
            nargs = "?",
        },
        command = function(c)
            local args = vim.split(c.args, " ")
            local ft = args[1]
            local name = args[2]
            playground.create_playground({ ft = ft, name = name })
        end,
    },
    {
        name = "PlaygroundSearch",
        opts = {
            desc = "playground: search",
        },
        command = function()
            playground.search_playgrounds()
        end,
    },
    {
        name = "PlaygroundSelect",
        opts = {
            desc = "playground: select",
        },
        command = function()
            playground.select_playground()
        end,
    },
    {
        name = "PlaygroundDelete",
        opts = {
            desc = "playground: delete",
        },
        command = function()
            playground.cleanup()
        end,
    },
    {
        name = "PlaygroundDeleteAll",
        opts = {
            desc = "playground: delete all playgrounds",
        },
        command = function()
            playground.cleanup(true)
        end,
    },
}


function M.setup()
    for _, cmd in ipairs(CMDS) do
        local opts = vim.tbl_extend("force", cmd.opts, { force = true })
        vim.api.nvim_create_user_command(cmd.name, cmd.command, opts)
    end
end

return M
