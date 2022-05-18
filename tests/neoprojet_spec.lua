describe('neoprojet', function()
    local neoprojet = require('neoprojet')

    before_each(function()
        neoprojet.delete_all_projects()
    end)

    it('Project exists', function()
        neoprojet.register_new_project()
        assert.same(true, neoprojet._project_exists())
    end)

    it('Project does not exist', function()
        assert.same(false, neoprojet._project_exists())
    end)

    it('Can delete projects', function()
        neoprojet.register_new_project()
        vim.api.nvim_command(':cd ..')
        neoprojet.register_new_project()
        neoprojet.delete_all_projects()
        assert.same({}, neoprojet.get_projects())
    end)

    it('Can rename project', function()
        local project_name = 'Test name'
        neoprojet.register_new_project()
        neoprojet.rename_project(project_name)
        assert.same(project_name, neoprojet.get_current_project().name)
    end)

    it('Can add command', function()
        local command_name = 'test'
        local command = ':echo should work'
        neoprojet.register_new_project()
        neoprojet.register_command(command_name, command)
        assert.same(
            {[command_name]=command},
            neoprojet.get_current_project().commands
        )
    end)

    it('Can call command', function()
        local command_name = 'test'
        local command = ':lua vim.api.nvim_buf_set_name(0, "smth")'
        neoprojet.register_new_project()
        neoprojet.register_command(command_name, command)
        neoprojet.call_command(command_name)
        assert.same(vim.fn.getcwd().."/smth", vim.api.nvim_buf_get_name(0))
    end)

    it('Can delete command', function()
        local command_name = 'test'
        local command = ':echo "test"'
        neoprojet.register_new_project()
        neoprojet.register_command(command_name, command)
        neoprojet.delete_command(command_name)
        assert.same({}, neoprojet.get_current_project().commands)
    end)
end)
