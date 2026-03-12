local M = {}

M.config = {
  templates_dir = vim.fn.stdpath("config") .. "/templates",
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

function M.render(lines)
  local title = vim.fn.expand("%:t:r")
  local date = os.date("%Y-%m-%d")
  local modified = os.date("%Y-%m-%d %H:%M")

  local vars = {
    title = title,
    date = date,
    modified = modified,
  }

  local result = {}

  for _, line in ipairs(lines) do
    line = line:gsub("{{(%w+)}}", function(key)
      return vars[key] or ""
    end)
    table.insert(result, line)
  end

  return result
end

function M.insert_template(name)
  local path = M.config.templates_dir .. "/" .. name .. ".md"

  if vim.fn.filereadable(path) == 0 then
    vim.notify("Template not found: " .. path)
    return
  end

  local lines = vim.fn.readfile(path)
  local rendered = M.render(lines)

  vim.api.nvim_buf_set_lines(0, 0, 0, false, rendered)
end

function M.list_templates()
  local files = vim.fn.globpath(M.config.templates_dir, "*.md", false, true)

  local result = {}

  for _, file in ipairs(files) do
    table.insert(result, vim.fn.fnamemodify(file, ":t:r"))
  end

  return result
end

function M.update_modified()
  local modified = os.date("%Y-%m-%d %H:%M")

  vim.cmd([[silent! %s/^modified:.*/modified: ]] .. modified)
end

return M
