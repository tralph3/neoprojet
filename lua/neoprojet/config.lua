local M = {}

local config = {
    project_dir_path = vim.fn.stdpath('data')..'/neoprojet',
    save_sessions = true,
    load_sessions = true,
}

M.extend = function(override)
    config = vim.tbl_extend('force', config, override or {})
end

M.get = function(key)
    return config[key]
end

M.set = function(key, value)
    config[key] = value
end

return M
