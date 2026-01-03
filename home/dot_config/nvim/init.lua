-- ~/.config/nvim/init.lua
-- Neovim Configuration - Managed by chezmoi

-- Set leader key before lazy
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load configuration modules
require("config.options")
require("config.keymaps")
require("config.lazy")

-- Set colorscheme after plugins load
vim.cmd.colorscheme("catppuccin")
