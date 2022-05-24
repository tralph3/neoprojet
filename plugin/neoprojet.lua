local M = require('neoprojet')

vim.api.nvim_create_autocmd('VimLeavePre', {
    callback = M.write_projects
})


-- REGISTER --
vim.api.nvim_create_user_command(
    'NPRegisterProject', function(args)
        M.register_project(args.fargs[1])
    end,
    { nargs='?' }
)

vim.api.nvim_create_user_command(
    'NPRegisterCommand', function(args)
        local command_name = args.fargs[1]
        table.remove(args.fargs, 1)
        local command = table.concat(args.fargs, " ")
        M.register_command(command_name, command)
    end,
    { nargs='+' }
)


-- MODIFY --
vim.api.nvim_create_user_command(
    'NPRenameProject', function(args)
        M.rename_project(args.fargs[1], args.fargs[2])
    end,
    { nargs='+' }
)


-- DELETE --
vim.api.nvim_create_user_command(
    'NPDeleteProject', function(args)
        M.delete_project(args.fargs[1])
    end,
    { nargs='?' }
)

vim.api.nvim_create_user_command(
    'NPDeleteAllProjects', M.delete_all_projects, { nargs=0 }
)

vim.api.nvim_create_user_command(
    'NPDeleteCommand', function(args)
        M.delete_command(args.fargs[1], args.fargs[2])
    end,
    { nargs='+' }
)


-- QUERY --
vim.api.nvim_create_user_command(
    'NPCallCommand', function(args)
        M.call_command(args.fargs[1], args.fargs[2])
    end,
    { nargs='+' }
)

vim.api.nvim_create_user_command(
    'NPPrintProject', function(args)
        local proj = M.get_project(args.fargs[1])
        print(vim.inspect(proj))
    end,
    { nargs='?' }
)
vim.api.nvim_create_user_command(
    'NPPrintProjects', function()
        local proj = M.get_projects()
        print(vim.inspect(proj))
    end,
    { nargs=0 }
)
