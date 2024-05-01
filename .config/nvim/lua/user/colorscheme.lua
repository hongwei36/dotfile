local colorscheme = "habamax"

-- catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
-- local colorscheme = "catppuccin-mocha"

local status_ok, _ = pcall(vim.cmd.colorscheme, colorscheme)
if not status_ok then
  return
end
