require("config.lazy")
require("lspconfig").ruff.setup({})
require("lspconfig").dockerls.setup({})

require("luarocks-nvim").setup()
require("devcontainer").setup({})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.py", -- Adjust the pattern to target specific file types
  callback = function()
    vim.lsp.buf.format({ async = false }) -- Sync formatting before saving
  end,
})
