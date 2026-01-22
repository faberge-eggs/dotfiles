-- Neo-tree Configuration
require("neo-tree").setup({
  close_if_last_window = true,
  event_handlers = {
    {
      event = "neo_tree_buffer_enter",
      handler = function()
        vim.opt_local.scrolloff = 0
      end,
    },
  },
  window = {
    position = "right",
    width = 35,
  },
  enable_git_status = false,
  enable_modified_markers = false,
  default_component_configs = {
    icon = {
      folder_closed = ">",
      folder_open = "v",
      folder_empty = ">",
      default = "*",
    },
    modified = {
      symbol = "",
    },
    git_status = {
      symbols = {
        added = "",
        modified = "",
        deleted = "",
        renamed = "",
        untracked = "",
        ignored = "",
        unstaged = "",
        staged = "",
        conflict = "",
      },
    },
  },
  renderers = {
    file = {
      { "indent" },
      { "name" },
    },
    directory = {
      { "indent" },
      { "icon" },
      { "name" },
    },
  },
  filesystem = {
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_hidden = false,
    },
    scan_mode = "deep",
    follow_current_file = {
      enabled = false,
    },
    use_libuv_file_watcher = false,
    bind_to_cwd = false,
    hijack_netrw_behavior = "disabled",
  },
})

-- Keymaps
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle file explorer" })
vim.keymap.set("n", "<leader>o", "<cmd>Neotree focus<cr>", { desc = "Focus file explorer" })
