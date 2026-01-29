-- Nvim-tree Configuration
require("nvim-tree").setup({
  disable_netrw = true,
  hijack_netrw = true,
  sync_root_with_cwd = false,
  reload_on_bufenter = false,
  update_focused_file = {
    enable = false,  -- Don't update tree when switching files
    update_root = false,  -- Don't change root directory
  },
  view = {
    width = 35,
    side = "right",
  },
  on_attach = function(bufnr)
    local api = require("nvim-tree.api")

    -- Use default keymaps
    api.config.mappings.default_on_attach(bufnr)

    -- Disable scrolloff in tree window
    vim.defer_fn(function()
      local wins = vim.api.nvim_list_wins()
      for _, win in ipairs(wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        if buf == bufnr then
          vim.api.nvim_set_option_value("scrolloff", 0, { scope = "local", win = win })
          vim.api.nvim_set_option_value("sidescrolloff", 0, { scope = "local", win = win })
        end
      end
    end, 0)
  end,
  renderer = {
    icons = {
      show = {
        file = false,
        folder = false,
        folder_arrow = true,
        git = false,
      },
      glyphs = {
        folder = {
          arrow_closed = ">",
          arrow_open = "v",
        },
      },
    },
  },
  filters = {
    dotfiles = false,
    custom = {},
  },
  git = {
    enable = false,
  },
  filesystem_watchers = {
    enable = false,  -- Disable file system watcher to avoid event spam
  },
})

-- Keymaps
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file explorer" })
vim.keymap.set("n", "<leader>r", "<cmd>NvimTreeFindFile<cr>", { desc = "Reveal file in explorer" })

