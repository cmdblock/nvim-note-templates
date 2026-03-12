local M = {}

local config = {
  templates_dir = vim.fn.stdpath("config") .. "/templates",
  default_template = "note.md",
}

M.setup = function(opts)
  config = vim.tbl_deep_extend("force", config, opts or {})
end

M.get_config = function()
  return config
end

return M
