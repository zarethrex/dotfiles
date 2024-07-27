require("config.lazy")
require("lspconfig").ruff_lsp.setup({})
require("code_runner").setup({})
require("cmp").setup({
  sources = {
    { name = "git" },
    -- more sources
  },
})
require("cmp_git").setup()
require("luarocks-nvim").setup()
