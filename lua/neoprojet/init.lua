local M = {}

local config = require('neoprojet.config')
M = vim.tbl_extend('force', M, require('neoprojet.projects'))

M.setup = function(opts)
    config.extend(opts)
    config.set(
        'project_data_path', config.get('project_dir_path')..'/projects.json'
    )
    config.set(
        'sessions_path', config.get('project_dir_path')..'/sessions'
    )
    if vim.fn.empty(vim.fn.glob(config.get('project_dir_path'))) > 0 then
        vim.fn.system('mkdir '..config.get('project_dir_path'))
        vim.fn.system('mkdir '..config.get('sessions_path'))
    end

    M.read_projects()

    M.call_init_command()
end

return M
