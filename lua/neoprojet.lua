local M = {}

local projects = {}
local project_dir_path = vim.fn.stdpath('data')..'/neoprojet'
local project_data_path = project_dir_path..'/projects.json'
local config = {}

local function read_file(file_path)
    local file = io.open(file_path, 'r')
    if file == nil then
        return nil
    end
    local contents = file:read('*a')
    io.close(file)
    return contents
end

local function write_file(file_path, contents)
    local file = io.open(file_path, 'w')
    if file == nil then
        return nil
    end
    file:write(contents)
    io.close(file)
end

M._write_projects = function()
    local projects_json = vim.fn.json_encode(projects)

    write_file(project_data_path, projects_json)
end

M._read_projects = function()
    local contents = read_file(project_data_path)
    local status_ok, stored_projects = pcall(vim.fn.json_decode, contents)
    if not status_ok or stored_projects == vim.NIL then
        return
    end
    projects = stored_projects
end

M._project_exists = function()
    local cwd = vim.fn.getcwd()

    return not(projects[cwd] == nil)
end

M._command_exists = function(command_name)
    local project = M.get_current_project()
    return not(project.commands[command_name] == nil)
end

M.get_current_project = function()
    local cwd = vim.fn.getcwd()
    return projects[cwd]
end

M._get_projects_telescope = function()
    local proj_tbl = M.get_projects()
    local telescope_tbl = {}
    for _, v in pairs(proj_tbl) do
        table.insert(telescope_tbl, v)
    end
    return telescope_tbl
end

M.register_new_project = function(project_name)
    if M._project_exists() then
        vim.notify('This project is already registered.')
        return
    end

    local cwd = vim.fn.getcwd()
    projects[cwd] = {}
    projects[cwd].commands = {}
    projects[cwd].path = cwd
    if project_name ~= "" then
        projects[cwd].name = project_name
    else
        projects[cwd].name = cwd
    end
end

M.rename_project = function(project_name)
    if not(M._project_exists()) then
        vim.notify('The current working directory is not registered as a project.')
        return
    end

    local project = M.get_current_project()
    project.name = project_name
end

M.delete_command = function(command_name)
    if not(M._project_exists()) then
        vim.notify('The current working directory is not registered as a project.')
        return
    end

    if not(M._command_exists(command_name)) then
        vim.notify(string.format(
            'Command "%s" does not exist in this project.', command_name
        ))
        return
    end

    local project = M.get_current_project()
    project.commands[command_name] = nil
end

M.delete_all_projects = function()
    projects = {}
end

M.delete_project = function()
    if not(M._project_exists()) then
        vim.notify('The current working directory is not registered as a project.')
        return
    end
    local cwd = vim.fn.getcwd()
    projects[cwd] = nil
end

M.register_command = function(command_name, command)
    if not(M._project_exists()) then
        return
    end

    local project = M.get_current_project()
    project.commands[command_name] = command
end

M.call_command = function(command_name)
    if not(M._project_exists()) then
        return
    end

    local project = M.get_current_project()

    if M._command_exists(command_name) then
        local command = project.commands[command_name]
        vim.notify(string.format(
            'Executing command "%s": %s', command_name, command
        ))
        vim.api.nvim_command(command)
    else
        vim.notify(string.format(
            'Command "%s" does not exist in this project.', command_name
        ))
    end
end

M.get_projects = function()
    return projects
end

M.setup = function(opts)
    config = vim.tbl_extend('force', config, opts or {})
    if vim.fn.empty(vim.fn.glob(project_dir_path)) > 0 then
        vim.fn.system('mkdir '..project_dir_path)
    end

    M._read_projects()
end

return M
