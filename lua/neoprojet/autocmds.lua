local np = require('neoprojet')
local config = require('neoprojet.config')

vim.api.nvim_create_autocmd('VimLeavePre', {
    callback = function(_)
        np.write_projects()
        if config.get('sessions') then
            np.save_session()
        end
    end,
})

vim.api.nvim_create_autocmd('DirChanged', {
    callback = function(_)
        if config.get('sessions') then
            np.load_session()
        end
        np.call_enter_command()
    end,
})

vim.api.nvim_create_autocmd('DirChangedPre', {
    callback = function(_)
        np.call_leave_command()
        if config.get('sessions') then
            np.save_session()
        end
    end,
})

