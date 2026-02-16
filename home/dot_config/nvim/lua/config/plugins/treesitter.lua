-- Treesitter Configuration
-- Try to load configs module (works in most nvim-treesitter versions)
local status_ok, ts_configs = pcall(require, "nvim-treesitter.configs")

if status_ok then
  ts_configs.setup({
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
else
  vim.notify("nvim-treesitter.configs not found. Treesitter highlighting may not work properly.", vim.log.levels.WARN)
end
