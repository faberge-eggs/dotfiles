-- LSP Configuration
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Mason setup
require("mason").setup({
  ui = {
    border = "rounded",
    icons = {
      package_installed = "+",
      package_pending = "~",
      package_uninstalled = "-",
    },
  },
})

require("mason-lspconfig").setup({
  ensure_installed = {
    "gopls",
    "pyright",
    -- solargraph installed via gem, not Mason
    "terraformls",
    "yamlls",
    "lua_ls",
  },
  automatic_installation = true,
})

-- Diagnostic config (Neovim 0.11+ style)
vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN] = "W",
      [vim.diagnostic.severity.HINT] = "H",
      [vim.diagnostic.severity.INFO] = "I",
    },
  },
})

-- LSP keymaps on attach
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(ev)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
    end

    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
    map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
    map("n", "gr", vim.lsp.buf.references, "Go to references")
    map("n", "K", vim.lsp.buf.hover, "Hover documentation")
    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
    map("n", "<leader>cs", vim.lsp.buf.signature_help, "Signature help")
    map("n", "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")
  end,
})

-- Server configurations
vim.lsp.config("gopls", {
  capabilities = capabilities,
  settings = {
    gopls = {
      analyses = { unusedparams = true },
      staticcheck = true,
    },
  },
})

vim.lsp.config("pyright", { capabilities = capabilities })
vim.lsp.config("solargraph", {
  capabilities = capabilities,
  cmd = { "/opt/homebrew/lib/ruby/gems/3.4.0/bin/solargraph", "stdio" },
})
vim.lsp.config("terraformls", { capabilities = capabilities })

vim.lsp.config("yamlls", {
  capabilities = capabilities,
  settings = {
    yaml = {
      keyOrdering = false,
      schemas = {
        kubernetes = "/*.k8s.yaml",
        ["http://json.schemastore.org/kustomization"] = "kustomization.yaml",
      },
    },
  },
})

vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
})

-- Enable servers
vim.lsp.enable({ "gopls", "pyright", "solargraph", "terraformls", "yamlls", "lua_ls" })

-- Disable LSP diagnostics for .tfvars files (keep only formatting)
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("DisableTfvarsLsp", { clear = true }),
  pattern = "*.tfvars",
  callback = function(ev)
    vim.diagnostic.enable(false, { bufnr = ev.buf })
  end,
})
