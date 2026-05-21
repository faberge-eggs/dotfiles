-- Treesitter Configuration (new API: nvim-treesitter >= 0.9)
require("nvim-treesitter").setup({
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
})

-- Enable treesitter highlighting and indent
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    local ok = pcall(vim.treesitter.start)
    if not ok then
      -- Silently ignore if no parser for this filetype
    end
  end,
})
