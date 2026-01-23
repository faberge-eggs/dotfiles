-- Formatting and Linting Configuration

-- Conform (formatter)
require("conform").setup({
  formatters_by_ft = {
    go = { "gofmt", "goimports" },
    python = { "black" },
    ruby = { "rubocop" },
    terraform = { "terraform_fmt" },
    hcl = { "terraform_fmt" },
    yaml = { "prettier" },
    json = { "prettier" },
    lua = { "stylua" },
    sh = { "shfmt" },
    bash = { "shfmt" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
})

vim.keymap.set("n", "<leader>cf", function()
  require("conform").format({ async = true })
end, { desc = "Format buffer" })

-- nvim-lint (linter)
local lint = require("lint")
lint.linters_by_ft = {
  go = { "golangcilint" },
  python = { "pylint" },
  ruby = { "rubocop" },
  terraform = { "tflint" },
  yaml = { "yamllint" },
}

-- Only lint on save (not BufEnter) to avoid errors with missing linters
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  group = vim.api.nvim_create_augroup("lint", { clear = true }),
  callback = function()
    -- Skip linting for all .tfvars files (keep only formatting)
    local filename = vim.fn.expand("%:t")
    if filename:match("%.tfvars$") then
      return
    end
    -- Silently try to lint, ignore errors for missing linters
    pcall(lint.try_lint)
  end,
})
