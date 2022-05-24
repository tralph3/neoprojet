describe('neoprojet', function()
    local np = require('neoprojet')

    before_each(function()
        np.delete_all_projects()
    end)

    it('Project exists', function()
        np.register_project()
        assert.same(true, np.project_exists())
    end)

    it('Project exists with name', function()
        local project_name = 'Fal'
        np.register_project(project_name)
        assert.same(true, np.project_exists(project_name))
    end)

    it('Project does not exist', function()
        assert.same(false, np.project_exists())
    end)

    it('Project does not exist with name', function()
        assert.same(false, np.project_exists('Tito'))
    end)

    it('Can delete projects', function()
        np.register_project()
        vim.api.nvim_command(':cd ..')
        np.register_project()
        np.delete_all_projects()
        assert.same({}, np.get_projects())
    end)

    it('Can rename project', function()
        local bad_name = 'serotier gui'
        local good_name = 'ZeroTier-GUI'
        np.register_project(bad_name)
        np.rename_project(good_name, bad_name)
        assert.same(good_name, np.get_project().name)
    end)

    it('Can add command', function()
        local command_name = 'test'
        local command = ':echo should work'
        np.register_project()
        np.register_command(command_name, command)
        assert.same(
            { [command_name]=command },
            np.get_project().commands
        )
    end)

    it('Can call command', function()
        local command_name = 'test'
        local command = ':lua vim.api.nvim_buf_set_name(0, "smth")'
        np.register_project()
        np.register_command(command_name, command)
        np.call_command(command_name)
        assert.same(vim.fn.getcwd().."/smth", vim.api.nvim_buf_get_name(0))
    end)

    it('Can delete command', function()
        local command_name = 'test'
        local command = ':echo "test"'
        np.register_project()
        np.register_command(command_name, command)
        np.delete_command(command_name)
        assert.same({}, np.get_project().commands)
    end)
end)
