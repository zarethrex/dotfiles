return {
  "nvim-neotest/neotest-python",
  dependencies = {
    "nvim-neotest/neotest",
  },
  config = function()
    require("neotest-python")({
      dap = { justMyCode = false },
      args = { "--log-level", "DEBUG", "--no-cov" },
      runner = "pytest",
    })
  end,
}
