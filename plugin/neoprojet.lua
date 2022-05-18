local M = require('neoprojet')

vim.api.nvim_create_autocmd('VimLeavePre', {
    callback = M._write_projects
})

vim.api.nvim_create_user_command(
    'NPRegisterNewProject', function(args)
        M.register_new_project(args.fargs[1])
    end,
    { nargs='?' }
)

vim.api.nvim_create_user_command(
    'NPRenameProject', function(args)
        M.rename_project(args.fargs[1])
    end,
    { nargs=1 }
)

vim.api.nvim_create_user_command(
    'NPDeleteProject', function(args)
        M.delete_project()
    end,
    { nargs=0 }
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

vim.api.nvim_create_user_command(
    'NPCallCommand', function(args)
        M.call_command(args.fargs[1])
    end,
    { nargs=1 }
)

vim.api.nvim_create_user_command(
    'NPDeleteCommand', function(args)
        M.delete_command(args.fargs[1])
    end,
    { nargs=1 }
)

vim.api.nvim_create_user_command(
    'NPDeleteAllProjects', M.delete_all_projects, { nargs=0 }
)

vim.api.nvim_create_user_command(
    'NPPrintProjects', function()
        local proj = M.get_projects()
        print(vim.inspect(proj))
    end,
    { nargs=0 }
)