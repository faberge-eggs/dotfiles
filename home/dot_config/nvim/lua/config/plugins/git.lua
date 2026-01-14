-- Gitlinker Configuration (uses current branch)
require("gitlinker").setup({
  opts = {
    add_current_line_on_normal_mode = true,
    action_callback = require("gitlinker.actions").copy_to_clipboard,
    print_url = true,
  },
  callbacks = {
    ["github.com"] = function(url_data)
      url_data.rev = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")
      return require("gitlinker.hosts").get_github_type_url(url_data)
    end,
  },
  mappings = "<leader>gy",
})

-- Gitsigns Configuration
require("gitsigns").setup({
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "-" },
    changedelete = { text = "~" },
    untracked = { text = "?" },
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local map = function(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
    end

    -- Navigation
    map("n", "]h", gs.next_hunk, "Next hunk")
    map("n", "[h", gs.prev_hunk, "Previous hunk")

    -- Actions
    map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
    map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
    map("v", "<leader>gs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage hunk")
    map("v", "<leader>gr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset hunk")
    map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
    map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
    map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
    map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
    map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line")
    map("n", "<leader>gd", gs.diffthis, "Diff this")
  end,
})
