local np = require('neoprojet')

vim.api.nvim_create_autocmd('VimLeavePre', {
    callback = np.write_projects,
})

vim.api.nvim_create_autocmd('DirChanged', {
    callback = function(_) np.call_init_command() end,
})


-- REGISTER --
vim.api.nvim_create_user_command(
    'NPRegisterProject', function(args)
        np.register_project(args.fargs[1])
    end,
    { nargs='?' }
)

vim.api.nvim_create_user_command(
    'NPRegisterCommand', function(args)
        local command_name = args.fargs[1]
        table.remove(args.fargs, 1)
        local command = table.concat(args.fargs, " ")
        np.register_command(command_name, command)
    end,
    { nargs='+' }
)

vim.api.nvim_create_user_command(
    'NPSetInitCommand', function(args)
        np.set_init_command(args.fargs[1], args.fargs[2])
    end,
    { nargs='+', -- complete=function(_)
            -- local project = np.get_project()
            -- local return_value = ''
            -- for k, _ in project.commands do
            --     return_value = string.format('%s\n', k)
            -- end
            -- return return_value
        -- end
    }
)

vim.api.nvim_create_user_command(
    'NPSetLeaveCommand', function(args)
        np.set_leave_command(args.fargs[1], args.fargs[2])
    end,
    { nargs='+' }
)


-- MODIFY --
vim.api.nvim_create_user_command(
    'NPRenameProject', function(args)
        np.rename_project(args.fargs[1], args.fargs[2])
    end,
    { nargs='+' }
)

vim.api.nvim_create_user_command(
    'NPRenameCommand', function(args)
        np.rename_command(args.fargs[1], args.fargs[2], args.fargs[3])
    end,
    { nargs='+' }
)


-- DELETE --
vim.api.nvim_create_user_command(
    'NPDeleteProject', function(args)
        np.delete_project(args.fargs[1])
    end,
    { nargs='?' }
)

vim.api.nvim_create_user_command(
    'NPDeleteAllProjects', np.delete_all_projects, { nargs=0 }
)

vim.api.nvim_create_user_command(
    'NPDeleteCommand', function(args)
        np.delete_command(args.fargs[1], args.fargs[2])
    end,
    { nargs='+' }
)


-- QUERY --
vim.api.nvim_create_user_command(
    'NPCallCommand', function(args)
        np.call_command(args.fargs[1], args.fargs[2])
    end,
    { nargs='+' }
)

vim.api.nvim_create_user_command(
    'NPCallInitCommand', function(args)
        np.call_init_command(args.fargs[1])
    end,
    { nargs='?' }
)

vim.api.nvim_create_user_command(
    'NPCallLeaveCommand', function(args)
        np.call_leave_command(args.fargs[1])
    end,
    { nargs='?' }
)

vim.api.nvim_create_user_command(
    'NPPrintProject', function(args)
        local proj = np.get_project(args.fargs[1])
        print(vim.inspect(proj))
    end,
    { nargs='?' }
)
vim.api.nvim_create_user_command(
    'NPPrintProjects', function()
        local proj = np.get_projects()
        print(vim.inspect(proj))
    end,
    { nargs=0 }
)
