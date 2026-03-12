local M = {}

function M.pick()
  local nt = require("note_templates")

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local state = require("telescope.actions.state")

  local templates = nt.list_templates()

  pickers
    .new({}, {
      prompt_title = "Note Templates",
      finder = finders.new_table({ results = templates }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(_, map)
        map("i", "<CR>", function(prompt_bufnr)
          local selection = state.get_selected_entry()
          actions.close(prompt_bufnr)

          nt.insert_template(selection[1])
        end)

        return true
      end,
    })
    :find()
end

return M
