return {
	"kdheepak/nvim-dap-julia",
	ft = "julia",
	dependencies = {
		"mfussenegger/nvim-dap",
		config = function()
			require("nvim-dap-julia").setup()
		end,
	},
}
