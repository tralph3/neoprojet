local M = {}

local projects = {}
local config = require('neoprojet.config')
local utils = require('neoprojet.utils')

local project_not_registered_error = 'This project is not registered.'
local project_registered_error = 'This project is already registered.'
local function argument_not_optional_error(argument_name)
    return string.format('Argument %s is not optional.', argument_name)
end


-- REGISTER --
M.register_project = function(project_name)
    assert(not M.project_exists(), project_registered_error)

    local cwd = vim.fn.getcwd()

    projects[cwd] = {}
    if project_name ~= '' then
        projects[cwd].name = project_name
    else
        projects[cwd].name = cwd
    end
    projects[cwd].init_command = ''
    projects[cwd].leave_command = ''
    projects[cwd].default_file = ''
    projects[cwd].commands = {}
end

M.register_command = function(command_name, command)
    assert(command_name ~= nil, argument_not_optional_error('command_name'))
    assert(command ~= nil, argument_not_optional_error('command'))
    assert(M.project_exists(), project_not_registered_error)

    M.get_project().commands[command_name] = command
end

M.set_init_command = function(command_name, project_name)
    assert(command_name ~= nil, argument_not_optional_error('command_name'))
    assert(M.project_exists(), project_not_registered_error)

    M.get_project(project_name).init_command = command_name
end

M.set_leave_command = function(command_name, project_name)
    assert(command_name ~= nil, argument_not_optional_error('command_name'))
    assert(M.project_exists(), project_not_registered_error)

    M.get_project(project_name).leave_command = command_name
end


-- MODIFY --
M.rename_project = function(new_name, project_name)
    assert(new_name ~= nil, argument_not_optional_error('new_name'))
    assert(M.project_exists(project_name), project_not_registered_error)

    M.get_project(project_name).name = new_name
end

M.rename_command = function(old_name, new_name, project_name)
    assert(old_name ~= nil, argument_not_optional_error('old_name'))
    assert(new_name ~= nil, argument_not_optional_error('new_name'))
    assert(M.project_exists(project_name), project_not_registered_error)

    local project = M.get_project(project_name)
    local command = project.commands[old_name]

    project.commands[old_name] = nil
    project.commands[new_name] = command
end


-- DELETE --
M.delete_command = function(command_name, project_name)
    assert(command_name ~= nil, argument_not_optional_error('command_name'))
    assert(M.project_exists(project_name), project_not_registered_error)

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
    assert(command_name ~= nil, argument_not_optional_error('command_name'))
    assert(M.project_exists(project_name), project_not_registered_error)

    local command = M.get_project(project_name).commands[command_name]
    vim.api.nvim_command(command or '')
end

M.call_init_command = function(project_name)
    if not M.project_exists(project_name) then
        return
    end

    local project = M.get_project(project_name)
    M.call_command(project.init_command, project_name)
end

M.call_leave_command = function(project_name)
    if not M.project_exists(project_name) then
        return
    end

    local project = M.get_project(project_name)
    M.call_command(project.leave_command, project_name)
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
    projects = vim.tbl_extend('force', projects, stored_projects or {})
end

M.write_projects = function()
    local projects_json = vim.fn.json_encode(projects)

    utils.write_file(config.get('json_path'), projects_json)
end

return M
