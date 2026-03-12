local M = {}

M.config = {
  templates_dir = vim.fn.stdpath("config") .. "/templates",
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

function M.render(lines)
  local title = vim.fn.expand("%:t:r")
  if title == "" or title == nil then title = "Untitled" end
  local date = os.date("%Y-%m-%d")
  local time = os.date("%H:%M")
  local datetime = os.date("%Y-%m-%d %H:%M")

  local vars = {
    title = title,
    date = date,
    time = time,
    modified = datetime,
    datetime = datetime,
  }

  local result = {}

  for _, line in ipairs(lines) do
    -- Support {{var}}
    line = line:gsub("{{(%w+)}}", function(key)
      return vars[key] or "{{" .. key .. "}}"
    end)
    
    -- Support <% tp.file.title %>
    line = line:gsub("<%% *tp%.file%.title *%%>", vars.title)
    
    -- Support <% tp.date.now("...") %> or <% tp.date.now() %>
    line = line:gsub("<%% *tp%.date%.now%(.-%) *%%>", vars.date)
    
    -- Support <% tp.file.last_modified_date(...) %>
    line = line:gsub("<%% *tp%.file%.last_modified_date%(.-%) *%%>", vars.modified)
    
    -- Support <% tp.date.yesterday("...") %>
    line = line:gsub("<%% *tp%.date%.yesterday%(.-%) *%%>", os.date("%Y-%m-%d", os.time() - 86400))
    
    -- Support <% tp.date.tomorrow("...") %>
    line = line:gsub("<%% *tp%.date%.tomorrow%(.-%) *%%>", os.date("%Y-%m-%d", os.time() + 86400))
    
    table.insert(result, line)
  end

  return result
end

function M.insert_template(name, bufnr)
  bufnr = bufnr or 0
  local path = M.config.templates_dir .. "/" .. name .. ".md"

  if vim.fn.filereadable(path) == 0 then
    vim.notify("Template not found: " .. path, vim.log.levels.ERROR)
    return
  end

  local lines = vim.fn.readfile(path)
  local rendered = M.render(lines)

  -- Insert at the current cursor position instead of always at the top
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  -- nvim_buf_set_lines is 0-indexed, row is 1-indexed
  -- If we want to insert AFTER current line, use row, row
  -- If we want to replace current line if it's empty, or insert at current line
  local current_line = vim.api.nvim_get_current_line()
  if current_line == "" then
    vim.api.nvim_buf_set_lines(bufnr, row - 1, row, false, rendered)
  else
    vim.api.nvim_buf_set_lines(bufnr, row, row, false, rendered)
  end
end

function M.list_templates()
  if vim.fn.isdirectory(M.config.templates_dir) == 0 then
    vim.notify("Templates directory not found: " .. M.config.templates_dir, vim.log.levels.WARN)
    return {}
  end
  local files = vim.fn.globpath(M.config.templates_dir, "*.md", false, true)

  local result = {}

  for _, file in ipairs(files) do
    table.insert(result, vim.fn.fnamemodify(file, ":t:r"))
  end

  return result
end

function M.update_modified()
  local modified = os.date("%Y-%m-%d %H:%M")
  local save_cursor = vim.api.nvim_win_get_cursor(0)
  
  -- Use Lua to perform the replacement to avoid vim.cmd issues with special characters
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local changed = false
  for i, line in ipairs(lines) do
    if line:match("^modified:.*") then
      lines[i] = "modified: " .. modified
      changed = true
      break -- Only update the first one
    end
  end
  
  if changed then
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.api.nvim_win_set_cursor(0, save_cursor)
  end
end

return M
