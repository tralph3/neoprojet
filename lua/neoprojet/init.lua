local M = {}

local config = require('neoprojet.config')
M = vim.tbl_extend('force', M, require('neoprojet.projects'))

M.setup = function(opts)
    config.extend(opts)
    config.set(
        'project_directory', config.get('projects_base_directory')..'/neoprojet'
    )
    config.set(
        'project_data_path', config.get('project_directory')..'/projects.json'
    )
    config.set(
        'sessions_directory', config.get('project_directory')..'/sessions'
    )
    if vim.fn.empty(vim.fn.glob(config.get('project_directory'))) > 0 then
        vim.fn.system('mkdir '..config.get('project_directory'))
        vim.fn.system('mkdir '..config.get('sessions_directory'))
    end

    require('neoprojet.autocmds')

    M.read_projects()
    M.call_enter_command()
end

return M
