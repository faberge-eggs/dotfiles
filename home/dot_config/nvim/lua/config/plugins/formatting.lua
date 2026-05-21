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
    timeout_ms = 10000,
    lsp_fallback = false,
  },
})

vim.keymap.set("n", "<leader>cf", function()
  require("conform").format({ async = true })
end, { desc = "Format buffer" })

-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("conform_format_on_save", { clear = true }),
  callback = function(args)
    require("conform").format({ bufnr = args.buf, lsp_fallback = false, timeout_ms = 10000 })
  end,
})

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
