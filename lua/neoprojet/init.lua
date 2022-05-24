local M = {}

local config = require('neoprojet.config')
M = vim.tbl_extend('force', M, require('neoprojet.projects'))

M.setup = function(opts)
    config.extend(opts)
    config.set('json_path', config.get('project_dir_path')..'/projects.json')
    if vim.fn.empty(vim.fn.glob(config.get('project_dir_path'))) > 0 then
        vim.fn.system('mkdir '..config.get('project_dir_path'))
    end

    M.read_projects()
end

return M
