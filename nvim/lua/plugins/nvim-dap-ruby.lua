return {
  "suketa/nvim-dap-ruby",
  config = function()
    require("dap-ruby").setup()
  end,
  ft = { "ruby", "Vagrantfile" },
}
