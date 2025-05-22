return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-neotest/neotest-python",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-python")({
					dap = { justMyCode = false },
					runner = "pytest",
				}),
				["rustacean.neotest"] = {},
			},
		})
	end,
	keys = {
		{
			"<leader>tr",
			function()
				require("neotest").run.run()
			end,
			desc = "Run the nearest test",
		},
		{
			"<leader>tf",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "Run tests in current file",
		},
		{
			"<leader>ts",
			function()
				require("neotest").run.stop()
			end,
			desc = "Abort all tests",
		},
		{
			"<leader>tn",
			function()
				require("neotest").jump.next()
			end,
			desc = "Jump to next",
		},
		{
			"<leader>tN",
			function()
				require("neotest").jump.prev()
			end,
			desc = "Jump to previous",
		},
		{
			"<leader>tO",
			function()
				require("neotest").output.open()
			end,
			desc = "Open output",
		},
		{
			"<leader>to",
			function()
				require("neotest").output_panel.toggle()
			end,
			desc = "Show/hide output panel",
		},
		{
			"<leader>ts",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "Show/hide test summary",
		},
	},
}
