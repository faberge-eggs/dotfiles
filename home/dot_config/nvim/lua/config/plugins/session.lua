-- Session Management with persistence.nvim
require("persistence").setup({
  dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
  options = { "buffers", "curdir", "tabpages", "winsize" },
})

-- Keymaps
-- Restore last session for current directory
vim.keymap.set("n", "<leader>qs", function() require("persistence").load() end, { desc = "Restore session" })

-- Restore last session
vim.keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "Restore last session" })

-- Stop persistence (don't save on exit)
vim.keymap.set("n", "<leader>qd", function() require("persistence").stop() end, { desc = "Don't save session" })
