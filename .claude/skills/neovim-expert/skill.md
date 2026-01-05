---
name: neovim-expert
description: Expert in Neovim configuration with vim-plug, LSP, treesitter, and Lua configs. Use when working with Neovim setup, plugin management, LSP configuration, syntax highlighting, or keymaps.
allowed-tools: Read, Grep, Glob, Bash
---

# Neovim Expert

An expert skill for configuring Neovim with vim-plug plugin manager, LSP, treesitter, and Lua-based configuration.

## When to use this skill

Use this skill when:
- Setting up or modifying Neovim configuration
- Managing plugins with vim-plug
- Configuring LSP for various languages
- Setting up treesitter syntax highlighting
- Creating keymaps and autocommands
- Troubleshooting Neovim issues

## Directory structure

```
~/.config/nvim/
├── init.lua                 # Entry point
├── lua/
│   ├── config/
│   │   ├── options.lua      # Vim options
│   │   ├── keymaps.lua      # Key mappings
│   │   └── autocmds.lua     # Autocommands
│   └── plugins/             # Plugin configurations
│       ├── lsp.lua
│       ├── completion.lua
│       ├── treesitter.lua
│       └── ...
└── after/
    └── queries/             # Custom treesitter queries
```

## vim-plug Plugin Manager

### Bootstrap vim-plug in init.lua

```lua
local plug_path = vim.fn.stdpath("data") .. "/site/autoload/plug.vim"
if vim.fn.empty(vim.fn.glob(plug_path)) > 0 then
    vim.fn.system({
        "curl", "-fLo", plug_path, "--create-dirs",
        "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim",
    })
    vim.cmd("autocmd VimEnter * PlugInstall --sync | source $MYVIMRC")
end
```

### Declare plugins

```lua
local Plug = vim.fn["plug#"]
vim.call("plug#begin", vim.fn.stdpath("data") .. "/plugged")

-- Colorscheme
Plug("sjl/badwolf")

-- LSP
Plug("neovim/nvim-lspconfig")
Plug("williamboman/mason.nvim")
Plug("williamboman/mason-lspconfig.nvim")

-- Completion
Plug("hrsh7th/nvim-cmp")
Plug("hrsh7th/cmp-nvim-lsp")

-- Treesitter
Plug("nvim-treesitter/nvim-treesitter", { ["do"] = ":TSUpdate" })

vim.call("plug#end")
```

### Plugin commands

```bash
:PlugInstall    # Install plugins
:PlugUpdate     # Update plugins
:PlugClean      # Remove unused plugins
:PlugStatus     # Check plugin status
```

## LSP Configuration

### Neovim 0.11+ Native LSP API

```lua
-- Modern approach using vim.lsp.config() and vim.lsp.enable()
vim.lsp.config("gopls", {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.mod", ".git" },
})

vim.lsp.config("pyright", {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", ".git" },
})

-- Enable servers
vim.lsp.enable({ "gopls", "pyright", "lua_ls", "terraformls" })
```

### With Mason (LSP installer)

```lua
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "gopls",
        "pyright",
        "lua_ls",
        "terraformls",
        "yamlls",
    },
})
```

### LSP Keymaps

```lua
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    end,
})
```

## Treesitter Configuration

```lua
require("nvim-treesitter.config").setup({
    ensure_installed = {
        "bash", "go", "gomod", "gotmpl", "json", "lua",
        "markdown", "python", "ruby", "terraform", "toml",
        "vim", "vimdoc", "yaml",
    },
    highlight = { enable = true },
    indent = { enable = true },
})
```

### Disable treesitter for specific files

```lua
highlight = {
    enable = true,
    disable = function(lang, buf)
        local name = vim.api.nvim_buf_get_name(buf)
        return name:match("%.tmpl$")  -- Disable for .tmpl files
    end,
},
```

## Autocommands

### Filetype detection

```lua
vim.filetype.add({
    extension = {
        tmpl = function(path, bufnr)
            local filename = vim.fn.fnamemodify(path, ":t")
            -- Detect base filetype from chezmoi naming
            if filename:match("gitconfig") then return "gitconfig" end
            if filename:match("zshrc") then return "zsh" end
            if filename:match("%.sh") then return "bash" end
            if filename:match("%.toml") then return "toml" end
            return "gotmpl"
        end,
    },
})
```

### Custom syntax overlay (e.g., gotmpl in .tmpl files)

```lua
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    pattern = "*.tmpl",
    callback = function()
        vim.cmd([[
            syntax region gotmplBlock matchgroup=gotmplDelim start="{{-\?" end="-\?}}" containedin=ALL
            highlight link gotmplBlock Special
            highlight link gotmplDelim Special
        ]])
    end,
})
```

## Common Options

```lua
-- lua/config/options.lua
local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- UI
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Undo
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"
```

## Keymaps

```lua
-- lua/config/keymaps.lua
local map = vim.keymap.set

-- Leader key
vim.g.mapleader = " "

-- File operations
map("n", "<leader>w", ":w<CR>", { desc = "Save" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit" })

-- Window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Buffer navigation
map("n", "<S-h>", ":bprevious<CR>")
map("n", "<S-l>", ":bnext<CR>")

-- Clear search highlight
map("n", "<Esc>", ":nohlsearch<CR>")
```

## Critical Issues & Solutions

### Treesitter and Vim Syntax Conflict

**Problem**: When treesitter is enabled, vim syntax highlighting is disabled. This breaks custom syntax overlays.

**Solution**: Disable treesitter for specific files and use vim syntax:

```lua
-- In treesitter config
highlight = {
    enable = true,
    disable = function(lang, buf)
        return vim.api.nvim_buf_get_name(buf):match("%.tmpl$")
    end,
},

-- In autocmd, syntax overlay works because treesitter is disabled
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    pattern = "*.tmpl",
    callback = function()
        -- Base vim syntax is active, add overlay
        vim.cmd([[syntax region myBlock start="{{" end="}}" containedin=ALL]])
    end,
})
```

### LSP Deprecation Warning (Neovim 0.11+)

**Problem**: `require('lspconfig')` shows deprecation warnings.

**Solution**: Use native `vim.lsp.config()` and `vim.lsp.enable()`:

```lua
-- Old (deprecated)
require("lspconfig").gopls.setup({})

-- New (Neovim 0.11+)
vim.lsp.config("gopls", { cmd = { "gopls" } })
vim.lsp.enable("gopls")
```

### Mason LSP Installation Failures

**Problem**: Mason fails to install LSP servers (e.g., solargraph needs newer Ruby).

**Solution**: Install via system package manager and configure LSP to use system binary:

```lua
vim.lsp.config("solargraph", {
    cmd = { "/opt/homebrew/opt/ruby@3.4/bin/solargraph", "stdio" },
})
```

### Undo File Incompatibility

**Error**: `E824: Incompatible undo file`

**Solution**: Delete old undo files:
```bash
rm -rf ~/.vim/undodir/*
# or for neovim
rm -rf ~/.local/share/nvim/undo/*
```

## Plugin Recommendations

### Essential
- `nvim-lspconfig` - LSP configurations
- `mason.nvim` - LSP/DAP/linter installer
- `nvim-cmp` - Autocompletion
- `nvim-treesitter` - Syntax highlighting
- `telescope.nvim` - Fuzzy finder

### UI
- `lualine.nvim` - Statusline
- `bufferline.nvim` - Buffer tabs
- `neo-tree.nvim` - File explorer
- `which-key.nvim` - Keybinding help

### Editor
- `nvim-autopairs` - Auto close brackets
- `Comment.nvim` - Commenting
- `gitsigns.nvim` - Git integration
- `conform.nvim` - Formatting

### Colorschemes
- `gruvbox.nvim`
- `badwolf`
- `catppuccin`
- `tokyonight.nvim`

## Debugging

```vim
" Check filetype
:echo &filetype

" Check syntax
:echo &syntax

" Check if treesitter is active
:lua print(vim.b.ts_highlight)

" List syntax items
:syntax list

" Check highlight group under cursor
:echo synIDattr(synID(line('.'),col('.'),1),'name')

" View loaded LSP clients
:lua print(vim.inspect(vim.lsp.get_clients()))

" Check treesitter parsers
:TSInstallInfo
```

## Resources

When helping with Neovim:
- Prefer vim-plug for simpler plugin management (vs lazy.nvim)
- Use Neovim 0.11+ native LSP API when available
- Disable treesitter for files needing vim syntax overlay
- Always check `:checkhealth` for issues
- Use `BufWinEnter` for syntax overlays (not `BufRead`)
- Test filetype detection with `:echo &filetype`
