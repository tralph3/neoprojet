local M = {}

local projects = {}
local config = require('neoprojet.config')
local utils = require('neoprojet.utils')


-- REGISTER --
M.register_project = function(project_name)
    assert(not M.project_exists(), 'This project is already registered.')

    local cwd = vim.fn.getcwd()
    projects[cwd] = {}
    projects[cwd].commands = {}
    projects[cwd].init_command = ''
    if project_name ~= '' then
        projects[cwd].name = project_name
    else
        projects[cwd].name = cwd
    end
end

M.register_command = function(command_name, command)
    assert(command_name ~= nil, 'Parameter "command_name" is not optional.')
    assert(command ~= nil, 'Parameter "command" is not optional.')
    assert(M.project_exists(), 'This project is not registered.')

    M.get_project().commands[command_name] = command
end


-- MODIFY --
M.rename_project = function(new_name, project_name)
    assert(new_name ~= nil, 'Parameter "new_name" is not optional.')
    assert(M.project_exists(project_name), 'This project is not registered.')

    M.get_project(project_name).name = new_name
end


-- DELETE --
M.delete_command = function(command_name, project_name)
    assert(command_name ~= nil, 'Parameter "command_name" is not optional.')
    assert(M.project_exists(project_name), 'This project is not registered.')

    M.get_project(project_name).commands[command_name] = nil
end

M.delete_all_projects = function()
    projects = {}
end

M.delete_project = function(project_name)
    if not project_name then
        local cwd = vim.fn.getcwd()
        projects[cwd] = nil
        return
    end

    for k, v in pairs(projects) do
        if v.name == project_name then
            projects[k] = nil
        end
    end
end


-- QUERY --
M.get_project = function(project_name)
    if project_name then
        for _, v in pairs(projects) do
            if v.name == project_name then
                return v
            end
        end
    else
        local cwd = vim.fn.getcwd()
        return projects[cwd]
    end
end

M.get_projects = function()
    return projects
end

M.call_command = function(command_name, project_name)
    assert(command_name ~= nil, 'Parameter "command_name" is not optional.')
    assert(M.project_exists(project_name), 'This project is not registered.')

    local command = M.get_project(project_name).commands[command_name]
    vim.api.nvim_command(command or '')
end

M.project_exists = function(project_name)
    return M.get_project(project_name) ~= nil
end


-- FILESYSTEM --
M.read_projects = function()
    local contents = utils.read_file(config.get('json_path'))
    local status_ok, stored_projects = pcall(vim.fn.json_decode, contents)
    if not status_ok or stored_projects == vim.NIL then
        return
    end
    projects = stored_projects
end

M.write_projects = function()
    local projects_json = vim.fn.json_encode(projects)

    utils.write_file(config.get('json_path'), projects_json)
end

return M
