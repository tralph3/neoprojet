local np = require('neoprojet')

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
    'NPSetEnterCommand', function(args)
        np.set_enter_command(args.fargs[1], args.fargs[2])
    end,
    { nargs='+', complete=function(_)
            local commands = np.get_commands()
            if not commands then
                return
            end
            local results = {}
            for k, _ in pairs(commands) do
                table.insert(results, k)
            end
            return results
        end
    }
)

vim.api.nvim_create_user_command(
    'NPSetLeaveCommand', function(args)
        np.set_leave_command(args.fargs[1], args.fargs[2])
    end,
    { nargs='+', complete=function(_)
            local commands = np.get_commands()
            if not commands then
                return
            end
            local results = {}
            for k, _ in pairs(commands) do
                table.insert(results, k)
            end
            return results
        end
    }
)


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


vim.api.nvim_create_user_command(
    'NPDeleteProject', function(args)
        np.delete_project(args.fargs[1])
    end,
    { nargs='?' }
)

vim.api.nvim_create_user_command(
    'NPDeleteAllProjects', function(_)
        vim.ui.select({ 'Yes', 'No' }, { prompt='Delete all projects?' } ,
        function(choice)
            if choice == 'Yes' then
                np.delete_all_projects()
            end
        end)
    end,
    { nargs=0 }
)

vim.api.nvim_create_user_command(
    'NPDeleteCommand', function(args)
        np.delete_command(args.fargs[1], args.fargs[2])
    end,
    { nargs='+' }
)


vim.api.nvim_create_user_command(
    'NPCallCommand', function(args)
        np.call_command(args.fargs[1], args.fargs[2])
    end,
    { nargs='+' }
)

vim.api.nvim_create_user_command(
    'NPCallEnterCommand', function(args)
        np.call_enter_command(args.fargs[1])
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

vim.api.nvim_create_user_command(
    'NPSwitchProject', function(args)
        np.switch_project(args.fargs[1])
    end,
    { nargs=1, complete=function(_)
            local project_names = {}
            for _, v in pairs(np.get_projects()) do
                table.insert(project_names, v.name)
            end
            return project_names
        end
    }
)
