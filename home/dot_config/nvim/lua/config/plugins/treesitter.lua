-- Treesitter Configuration
require("nvim-treesitter.config").setup({
  ensure_installed = {
    "bash",
    "go",
    "gomod",
    "gosum",
    "gotmpl",
    "hcl",
    "json",
    "lua",
    "markdown",
    "python",
    "ruby",
    "terraform",
    "toml",
    "vim",
    "vimdoc",
    "yaml",
  },
  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = false,
      node_decremental = "<bs>",
    },
  },
})
