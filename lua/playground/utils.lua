local M = {}


--- Concatenate directories and/or file paths into a single path with normalization
--- (e.g., `"foo/"` and `"bar"` get joined to `"foo/bar"`)
--- Copy pasta from Nvim 0.10 :D
--- @param ... string
--- @return string
function M.joinpath(...)
    return (table.concat({ ... }, '/'):gsub('//+', '/'))
end

return M
