-- Autocommands

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Helper: detect base filetype from chezmoi .tmpl files
local function get_base_filetype(filename)
  -- Remove .tmpl extension
  local base = filename:gsub("%.tmpl$", "")

  -- Remove chezmoi prefixes
  base = base:gsub("^dot_", ".")
  base = base:gsub("^private_", "")
  base = base:gsub("^run_once_", "")
  base = base:gsub("^run_onchange_", "")
  base = base:gsub("^run_before_", "")
  base = base:gsub("^run_after_", "")

  -- Map extensions/filenames to filetypes
  if base:match("%.sh$") or base:match("^%.?bash") then
    return "bash"
  elseif base:match("%.zsh") or base:match("zshrc") or base:match("zshenv") or base:match("zprofile") then
    return "zsh"
  elseif base:match("gitconfig") then
    return "gitconfig"
  elseif base:match("%.env$") or base:match("^%.env") then
    return "sh"
  elseif base:match("%.toml$") then
    return "toml"
  elseif base:match("%.yaml$") or base:match("%.yml$") then
    return "yaml"
  elseif base:match("%.json$") then
    return "json"
  elseif base:match("%.lua$") then
    return "lua"
  elseif base:match("%.py$") then
    return "python"
  elseif base:match("%.rb$") then
    return "ruby"
  elseif base:match("%.go$") then
    return "go"
  elseif base:match("%.tf$") then
    return "terraform"
  elseif base:match("%.conf$") or base:match("%.cfg$") then
    return "conf"
  elseif base:match("%.vim$") or base:match("vimrc") then
    return "vim"
  end

  return nil
end

-- Filetype detection for .tmpl files with base type detection
vim.filetype.add({
  extension = {
    tmpl = function(path, bufnr)
      local filename = vim.fn.fnamemodify(path, ":t")
      return get_base_filetype(filename) or "gotmpl"
    end,
  },
  filename = {
    [".yamllint"] = "yaml",
  },
})

-- Add gotmpl syntax highlighting for {{ }} blocks in .tmpl files
augroup("GotmplSyntax", { clear = true })
autocmd({ "BufRead", "BufNewFile", "BufWinEnter" }, {
  group = "GotmplSyntax",
  pattern = "*.tmpl",
  callback = function()
    -- Simple approach: just highlight {{ }} blocks as Special
    vim.cmd([[
      syntax match gotmplBlock "{{-\?.\{-}-\?}}" containedin=ALL
      highlight link gotmplBlock Special
    ]])
  end,
})

-- Highlight on yank
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Remove trailing whitespace on save
augroup("TrimWhitespace", { clear = true })
autocmd("BufWritePre", {
  group = "TrimWhitespace",
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- Return to last edit position
augroup("RestoreCursor", { clear = true })
autocmd("BufReadPost", {
  group = "RestoreCursor",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Auto-resize splits when window is resized
augroup("ResizeSplits", { clear = true })
autocmd("VimResized", {
  group = "ResizeSplits",
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Filetype specific settings
augroup("FileTypeSettings", { clear = true })
autocmd("FileType", {
  group = "FileTypeSettings",
  pattern = { "go" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = false
  end,
})
autocmd("FileType", {
  group = "FileTypeSettings",
  pattern = { "python" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})
autocmd("FileType", {
  group = "FileTypeSettings",
  pattern = { "yaml", "terraform", "json" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})
