local M = {}

local config = {
    project_dir_path = vim.fn.stdpath('data')..'/neoprojet',
    sessions = true,
    default_enter_command = '',
    default_leave_command = '',
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
