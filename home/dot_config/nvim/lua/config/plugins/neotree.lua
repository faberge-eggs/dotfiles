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
    {
      event = "file_opened",
      handler = function(file_path)
        -- Prevent any action - no revealing
      end,
    },
    {
      event = "file_added",
      handler = function(file_path)
        -- Prevent any action
      end,
    },
    {
      event = "file_deleted",
      handler = function(file_path)
        -- Prevent any action
      end,
    },
    {
      event = "vim_buffer_enter",
      handler = function()
        -- Block buffer enter from triggering reveals
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
      leave_dirs_open = false,  -- Changed to false to prevent any auto behavior
    },
    use_libuv_file_watcher = false,
    bind_to_cwd = false,
    hijack_netrw_behavior = "disabled",
    group_empty_dirs = false,  -- Don't group empty directories
  },
})

-- Keymaps
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle file explorer" })
vim.keymap.set("n", "<leader>o", "<cmd>Neotree focus<cr>", { desc = "Focus file explorer" })
vim.keymap.set("n", "<leader>ef", "<cmd>Neotree reveal<cr>", { desc = "Reveal file in explorer" })
