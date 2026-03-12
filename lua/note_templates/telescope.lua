local M = {}

function M.pick()
  local nt = require("note_templates")

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local state = require("telescope.actions.state")

  local templates = nt.list_templates()
  
  if #templates == 0 then
    -- Already notified in list_templates
    return
  end

  pickers
    .new({}, {
      prompt_title = "Note Templates",
      finder = finders.new_table({ results = templates }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          local selection = state.get_selected_entry()
          if selection == nil then
            return
          end
          
          -- Get the name of the template
          local template_name = selection.value or selection[1]
          
          -- Close the picker first to return focus to the original buffer
          actions.close(prompt_bufnr)

          -- Now focus should be back, insert the template
          nt.insert_template(template_name)
        end)

        return true
      end,
    })
    :find()
end

return M
