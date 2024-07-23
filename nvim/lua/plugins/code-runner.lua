return {
  "CRAG666/code_runner.nvim",
  filetype = {
    python = "bash -c",
  },
  keys = {
    { "<leader>r", ":RunCode<CR>", { noremap = true, silent = false } },
  },
}
