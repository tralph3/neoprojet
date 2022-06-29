local status_ok, telescope = pcall(require, 'telescope')
if not status_ok then
  return
end

local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local config = require('telescope.config').values
local np = require('neoprojet')

local function make_command_list()
    local commands = np.get_commands()
    local command_list = {}
    for k, v in pairs(commands) do
        local entry = {k, v}
        table.insert(command_list, entry)
    end
    return command_list
end

local function projects(opts)
    opts = opts or {}
    pickers.new(opts, {
        prompt_title = "Projects",
        preview = true,
        finder = finders.new_table({
            results = np.get_all_projects(),
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = string.format(
                        "%-50s %-5s %s", entry.name:sub(1, 50), "", entry.root_path
                    ),
                    ordinal = entry.name,
                }
            end,
        }),
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                np.switch_project(selection.value.name)
            end)
            return true
        end,
        sorter = config.generic_sorter(opts),
    }):find()
end

local function commands(opts)
    opts = opts or {}
    pickers.new(opts, {
        prompt_title = "Commands",
        preview = false,
        finder = finders.new_table({
            results = make_command_list(),
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = string.format(
                        "%-50s %-5s %s", entry[1]:sub(1, 20), "", entry[2]
                    ),
                    ordinal = entry[1],
                }
            end,
        }),
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                np.call_command(selection.value[1])
            end)
            return true
        end,
        sorter = config.generic_sorter(opts),
    }):find()
end

return telescope.register_extension({
    exports = {
        projects = projects,
        commands = commands,
    },
})
