-- Neovim Configuration with vim-plug
-- Managed by chezmoi

-- Bootstrap vim-plug
local plug_path = vim.fn.stdpath("data") .. "/site/autoload/plug.vim"
if vim.fn.empty(vim.fn.glob(plug_path)) > 0 then
	vim.fn.system({
		"curl",
		"-fLo",
		plug_path,
		"--create-dirs",
		"https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim",
	})
	vim.cmd("autocmd VimEnter * PlugInstall --sync | source $MYVIMRC")
end

-- Load options and keymaps first
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Plugin declarations
local Plug = vim.fn["plug#"]
vim.call("plug#begin", vim.fn.stdpath("data") .. "/plugged")

-- Colorscheme
Plug("sjl/badwolf")
Plug("ellisonleao/gruvbox.nvim")

-- LSP
Plug("neovim/nvim-lspconfig")
Plug("williamboman/mason.nvim")
Plug("williamboman/mason-lspconfig.nvim")

-- Completion
Plug("hrsh7th/nvim-cmp")
Plug("hrsh7th/cmp-nvim-lsp")
Plug("hrsh7th/cmp-buffer")
Plug("hrsh7th/cmp-path")
Plug("hrsh7th/cmp-cmdline")
Plug("L3MON4D3/LuaSnip")
Plug("saadparwaiz1/cmp_luasnip")
Plug("rafamadriz/friendly-snippets")

-- Treesitter
Plug("nvim-treesitter/nvim-treesitter", { ["do"] = ":TSUpdate" })

-- Telescope
Plug("nvim-lua/plenary.nvim")
Plug("nvim-telescope/telescope.nvim", { branch = "0.1.x" })
Plug("nvim-telescope/telescope-fzf-native.nvim", { ["do"] = "make" })

-- File explorer
Plug("nvim-neo-tree/neo-tree.nvim", { branch = "v3.x" })
Plug("MunifTanjim/nui.nvim")

-- Git
Plug("lewis6991/gitsigns.nvim")

-- UI
Plug("nvim-lualine/lualine.nvim")
Plug("akinsho/bufferline.nvim")
Plug("folke/which-key.nvim")
Plug("lukas-reineke/indent-blankline.nvim")

-- Formatting & Linting
Plug("stevearc/conform.nvim")
Plug("mfussenegger/nvim-lint")

-- Editor
Plug("windwp/nvim-autopairs")
Plug("numToStr/Comment.nvim")
Plug("echasnovski/mini.surround")
Plug("echasnovski/mini.ai")
Plug("windwp/nvim-ts-autotag")

vim.call("plug#end")

-- Set colorscheme (fallback to default if not installed)
local ok, _ = pcall(vim.cmd, "colorscheme gruvbox")
if not ok then
	vim.cmd("colorscheme default")
end

-- Load plugin configurations (only if plugins are installed)
local function safe_require(module)
	local status, err = pcall(require, module)
	if not status then
		vim.notify("Failed to load " .. module .. ": " .. err, vim.log.levels.WARN)
	end
end

-- Check if plugins are installed
local plugged_path = vim.fn.stdpath("data") .. "/plugged"
if vim.fn.isdirectory(plugged_path .. "/nvim-cmp") == 1 then
	safe_require("config.plugins.lsp")
	safe_require("config.plugins.completion")
	safe_require("config.plugins.treesitter")
	safe_require("config.plugins.telescope")
	safe_require("config.plugins.neotree")
	safe_require("config.plugins.git")
	safe_require("config.plugins.ui")
	safe_require("config.plugins.formatting")
	safe_require("config.plugins.editor")
end
