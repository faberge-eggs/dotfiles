-- Neovim Options

-- Add Homebrew Ruby gems to PATH (for rubocop, solargraph, etc.)
vim.env.PATH = "/opt/homebrew/lib/ruby/gems/3.4.0/bin:/opt/homebrew/opt/ruby@3.4/bin:" .. vim.env.PATH

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Line wrapping
opt.wrap = false

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.colorcolumn = "80"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Behavior
opt.hidden = true
opt.errorbells = false
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.expand("~/.vim/undodir")
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.splitright = true
opt.splitbelow = true
opt.updatetime = 250
opt.timeoutlen = 300

-- Completion
opt.completeopt = "menu,menuone,noselect"
opt.shortmess:append("c")

-- File encoding
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- Disable netrw (using neo-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "
