local M = {}

M.read_file = function(file_path)
    local file = io.open(file_path, 'r')
    if file == nil then
        return nil
    end
    local contents = file:read('*a')
    io.close(file)
    return contents
end

M.write_file = function(file_path, contents)
    local file = io.open(file_path, 'w')
    if file == nil then
        return nil
    end
    file:write(contents)
    io.close(file)
end

return M
