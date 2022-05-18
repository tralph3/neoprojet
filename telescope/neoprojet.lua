local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local conf = require('telescope.config').values
local neoprojet = require('neoprojet')

local projects = function(opts)
    opts = opts or {}
    pickers.new(opts, {
        prompt_title = "Projects",
        finder = finders.new_table({
            results = neoprojet._get_projects_telescope(),
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.name,
                    ordinal = entry.name,
                }
            end,
        }),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                vim.api.nvim_put({ selection[1] }, "", false, true)
            end)
            return true
        end,
        sorter = conf.generic_sorter(opts),
    }):find()
end

projects()
