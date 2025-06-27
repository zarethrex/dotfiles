return {
	"mfussenegger/nvim-dap",
	config = function()
		require("dap").defaults.fallback.exception_breakpoints = { "raised" }
	end,
	keys = {
		{ "<leader>db", "<cmd>DapToggleBreakpoint<CR>" },
		{
			"<leader>dpr",
			function()
				local file_type = vim.bo.filetype
				if file_type == "python" then
					require("dap-python").test_method()
				elseif file_type == "julia" then
					require("nvim-dap-julia").test_method()
				end
			end,
			desc = "Run Python Debugger",
		},
		{
			"<leader>dc",
			"<cmd>DapContinue<CR>",
		},
		{
			"<leader>dt",
			"<cmd>DapTerminate<CR>",
		},
		{
			"<leader>dsO",
			"<cmd>DapStepOver<CR>",
		},
		{
			"<leader>dso",
			"<cmd>DapStepOut<CR>",
		},
		{
			"<leader>dsi",
			"<cmd>DapStepInto<CR>",
		},
		{
			"<leader>dr",
			"<cmd>DapToggleRepl<CR>",
		},
	},
}
