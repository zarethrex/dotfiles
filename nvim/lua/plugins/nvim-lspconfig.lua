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
    require("lspconfig").ansiblels.setup({
      filetypes = { "yaml.ansible" },
    })
    require("lspconfig").taplo.setup({
      filetypes = { "toml" },
    })
    require("lspconfig").ruby_lsp.setup({
      filetypes = {
        "ruby",
      },
    })
  end,
  opts = {
    servers = {
      ruff = {
        cmd_env = { RUFF_TRACE = "messages" },
        init_options = {
          settings = {
            logLevel = "error",
          },
        },
        keys = {
          {
            "<leader>co",
            LazyVim.lsp.action["source.organizeImports"],
            desc = "Organize Imports",
          },
        },
      },
      ruff_lsp = {
        keys = {
          {
            "<leader>co",
            LazyVim.lsp.action["source.organizeImports"],
            desc = "Organize Imports",
          },
        },
      },
      ruby_lsp = {
        enabled = lsp == "ruby_lsp",
      },
      solargraph = {
        enabled = lsp == "solargraph",
      },
      rubocop = {
        enabled = formatter == "rubocop",
      },
      standardrb = {
        enabled = formatter == "standardrb",
      },
    },
  },
}
