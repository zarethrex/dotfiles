return {
  "neovim/nvim-lspconfig",
  config = function()
    require("lspconfig").pyright.setup({
      file_types = { "python" },
      settings = {
        pyright = {
          -- Using Ruff's import organizer
          disableOrganizeImports = true,
        },
        python = {
          analysis = {
            -- Ignore all files for analysis to exclusively use Ruff for linting
            ignore = { "*" },
          },
        },
      },
    })
    require("lspconfig").ruff_lsp.setup({
      filetypes = { "python" },
    })
  end,
}
