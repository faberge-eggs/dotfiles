-- Editor Enhancements Configuration

-- Autopairs
local autopairs = require("nvim-autopairs")
autopairs.setup({
  check_ts = true,
  ts_config = {
    lua = { "string", "source" },
    javascript = { "string", "template_string" },
  },
})

-- Integration with nvim-cmp
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- Comment.nvim
require("Comment").setup({})

-- Mini.surround
require("mini.surround").setup({
  mappings = {
    add = "sa",
    delete = "sd",
    find = "sf",
    find_left = "sF",
    highlight = "sh",
    replace = "sr",
    update_n_lines = "sn",
  },
})

-- Mini.ai
require("mini.ai").setup({
  n_lines = 500,
})

-- nvim-ts-autotag
require("nvim-ts-autotag").setup({})
