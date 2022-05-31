local M = {}

M.read_file = function(file_path)
    local file = io.open(file_path, 'r')
    if not file then
        return
    end
    local contents = file:read('*a')
    io.close(file)
    return contents
end

M.write_file = function(file_path, contents)
    local file = io.open(file_path, 'w')
    if not file then
        return
    end
    file:write(contents)
    io.close(file)
end

M.encode_session_name = function(project_root_path)
    return project_root_path:gsub('/', '_')
end

return M
