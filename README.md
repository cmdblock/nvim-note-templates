# nvim-note-templates

A lightweight, Obsidian-friendly Markdown template system for Neovim with Telescope integration.

Inspired by Obsidian's Templater plugin, this plugin allows you to quickly insert templates into your Markdown notes with automatic variable replacement.

## ✨ Features

- 🚀 **Fast & Lightweight**: Written entirely in Lua.
- 🔭 **Telescope Integration**: Easily browse and pick templates.
- 📝 **Variable Replacement**: Supports both `{{var}}` and Obsidian Templater-like `<% tp... %>` syntax.
- 📅 **Dynamic Dates**: Supports current date, yesterday, and tomorrow.
- 🔄 **Auto-update**: Automatically updates `modified:` field in frontmatter on save.

## 📦 Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "yourname/nvim-note-templates",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  config = function()
    require("note_templates").setup({
      -- Default configuration
      templates_dir = vim.fn.stdpath("config") .. "/templates",
    })
  end,
  keys = {
    { "<leader>nt", "<cmd>NoteTemplatePick<cr>", desc = "Pick Note Template" },
  }
}
```

## ⚙️ Configuration

```lua
require("note_templates").setup({
  -- Path to your templates directory (must contain .md files)
  templates_dir = vim.fn.stdpath("config") .. "/templates",
})
```

## 🛠️ Usage

### Commands

- `:NoteTemplate {name}`: Insert a specific template (e.g., `:NoteTemplate daily`).
- `:NoteTemplatePick`: Open the Telescope picker to select a template.

### Supported Variables

You can use these in your `.md` templates:

| Variable | Description | Example Output |
| :--- | :--- | :--- |
| `{{title}}` / `<% tp.file.title %>` | Filename (without extension) | `My Note` |
| `{{date}}` / `<% tp.date.now() %>` | Current date | `2026-03-12` |
| `{{time}}` | Current time | `14:30` |
| `{{modified}}` / `<% tp.file.last_modified_date() %>` | Current Date & Time | `2026-03-12 14:30` |
| `<% tp.date.yesterday() %>` | Yesterday's date | `2026-03-11` |
| `<% tp.date.tomorrow() %>` | Tomorrow's date | `2026-03-13` |

## 📄 License

MIT
