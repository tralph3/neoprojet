local M = {}

local projects = {}
local config = require('neoprojet.config')
local utils = require('neoprojet.utils')

local project_not_registered_error = 'This project is not registered.'
local project_registered_error = 'This project is already registered.'
local function argument_not_optional_error(argument_name)
    return string.format('Argument "%s" is not optional.', argument_name)
end


M.register_project = function(project_name)
    assert(not M.project_exists(), project_registered_error)

    local project = {}
    local cwd = vim.fn.getcwd()

    if project_name ~= '' then
        project.name = project_name
    else
        project.name = cwd
    end
    project.root_path = cwd
    project.enter_command = config.get('default_enter_command')
    project.leave_command = config.get('default_leave_command')
    project.commands = {}
    table.insert(projects, project)
end

M.register_command = function(command_name, command)
    assert(command_name ~= nil, argument_not_optional_error('command_name'))
    assert(command ~= nil, argument_not_optional_error('command'))
    assert(M.project_exists(), project_not_registered_error)

    M.get_project().commands[command_name] = command
end

M.set_enter_command = function(command_name, project_name)
    assert(command_name ~= nil, argument_not_optional_error('command_name'))
    assert(M.project_exists(), project_not_registered_error)

    M.get_project(project_name).enter_command = command_name
end

M.set_leave_command = function(command_name, project_name)
    assert(command_name ~= nil, argument_not_optional_error('command_name'))
    assert(M.project_exists(), project_not_registered_error)

    M.get_project(project_name).leave_command = command_name
end


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


M.delete_command = function(command_name, project_name)
    assert(command_name ~= nil, argument_not_optional_error('command_name'))
    assert(M.project_exists(project_name), project_not_registered_error)

    M.get_project(project_name).commands[command_name] = nil
end

M.delete_all_projects = function()
    projects = {}
end

M.delete_project = function(project_name)
    local query_key = ''
    local query_value = ''
    if project_name then
        query_key = 'name'
        query_value = project_name
    else
        query_key = 'root_path'
        query_value = vim.fn.getcwd()
    end

    for k, v in pairs(projects) do
        if v[query_key] == query_value then
            table.remove(projects, k)
            return
        end
    end
end


M.get_project = function(project_name)
    local query_key = ''
    local query_value = ''
    if project_name then
        query_key = 'name'
        query_value = project_name
    else
        query_key = 'root_path'
        query_value = vim.fn.getcwd()
    end

    for _, v in pairs(projects) do
        if v[query_key] == query_value then
            return v
        end
    end
end

M.get_commands = function(project_name)
    local query_key = ''
    local query_value = ''
    if project_name then
        query_key = 'name'
        query_value = project_name
    else
        query_key = 'root_path'
        query_value = vim.fn.getcwd()
    end

    for _, v in pairs(projects) do
        if v[query_key] == query_value then
            return v.commands
        end
    end
end

M.get_all_projects = function()
    return projects
end

M.call_command = function(command_name, project_name)
    assert(command_name ~= nil, argument_not_optional_error('command_name'))
    assert(M.project_exists(project_name), project_not_registered_error)

    local command = M.get_project(project_name).commands[command_name]
    vim.api.nvim_command(command or '')
end

M.call_enter_command = function(project_name)
    if not M.project_exists(project_name) then
        return
    end

    local project = M.get_project(project_name)
    M.call_command(project.enter_command, project_name)
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

M.switch_project = function(project_name)
    assert(project_name ~= nil, argument_not_optional_error('project_name'))
    assert(M.project_exists(project_name), project_not_registered_error)

    local project = M.get_project(project_name)
    vim.api.nvim_command('cd '..project.root_path)
end

M.read_projects = function()
    local contents = utils.read_file(config.get('project_data_path'))
    local status_ok, stored_projects = pcall(vim.fn.json_decode, contents)
    if not status_ok or stored_projects == vim.NIL then
        return
    end
    projects = vim.tbl_extend('force', projects, stored_projects or {})
end

M.write_projects = function()
    local projects_json = vim.fn.json_encode(projects)

    utils.write_file(config.get('project_data_path'), projects_json)
end

M.save_session = function()
    if not M.project_exists() then
        return
    end
    local project = M.get_project()
    local session_name = utils.encode_session_name(project.root_path)
    local session_path = config.get('sessions_path')..'/'..session_name
    vim.api.nvim_command('silent mksession! '..session_path)
end

M.load_session = function()
    if not M.project_exists() then
        return
    end
    local project = M.get_project()
    local session_name = utils.encode_session_name(project.root_path)
    local session_path = config.get('sessions_path')..'/'..session_name
    vim.api.nvim_command('silent source '..session_path)
end

return M
