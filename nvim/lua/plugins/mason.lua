return {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      "debugpy",
      "mypy",
      "ruff-lsp",
      "pyright",
      "ansible-language-server",
      "ansible-lint",
    },
  },
}
