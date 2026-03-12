local nt = require("note_templates")

-- Enhanced command with auto-completion
vim.api.nvim_create_user_command("NoteTemplate", function(opts)
  nt.insert_template(opts.args)
end, {
  nargs = 1,
  complete = function()
    -- This provides auto-completion for the template names
    return nt.list_templates()
  end,
})

vim.api.nvim_create_user_command("NoteTemplatePick", function()
  require("note_templates.telescope").pick()
end, {})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.md",
  callback = function()
    nt.update_modified()
  end,
})
