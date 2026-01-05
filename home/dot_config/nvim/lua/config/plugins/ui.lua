-- UI Plugins Configuration

-- Lualine
require("lualine").setup({
  options = {
    icons_enabled = false,
    theme = "auto",
    component_separators = { left = "|", right = "|" },
    section_separators = { left = "", right = "" },
    globalstatus = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { { "filename", path = 3 } },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})

-- Bufferline
require("bufferline").setup({
  options = {
    mode = "buffers",
    numbers = "ordinal",
    indicator = { style = "underline" },
    show_buffer_icons = false,
    show_buffer_close_icons = false,
    show_close_icon = false,
    separator_style = "thin",
    diagnostics = "nvim_lsp",
    offsets = {
      {
        filetype = "neo-tree",
        text = "Files",
        highlight = "Directory",
        separator = true,
      },
    },
  },
})

vim.keymap.set("n", "<leader>bp", "<cmd>BufferLinePick<cr>", { desc = "Pick buffer" })
vim.keymap.set("n", "<leader>bc", "<cmd>BufferLinePickClose<cr>", { desc = "Pick close buffer" })

-- Which-key
local wk = require("which-key")
wk.setup({
  icons = { mappings = false },
})
wk.add({
  { "<leader>b", group = "buffer" },
  { "<leader>c", group = "code" },
  { "<leader>f", group = "find" },
  { "<leader>g", group = "git" },
  { "<leader>s", group = "split" },
})

-- Indent blankline
require("ibl").setup({
  indent = { char = "|" },
  scope = { enabled = false },
})
