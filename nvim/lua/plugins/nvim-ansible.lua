return {
  "mfussenegger/nvim-ansible",
  keys = {
    {
      "<leader>te",
      function()
        require("ansible").run()
      end,
    },
  },
}
