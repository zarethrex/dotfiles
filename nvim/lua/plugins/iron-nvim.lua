return {
	"Vigemus/iron.nvim",
	keys = {
		{ "<leader>ir", "<cmd>IronRepl<CR>", "Start Iron REPL" },
		{
			"<leader>is",
			function()
				require("iron.core").send(nil, vim.fn.getline("."))
			end,
			desc = "Send current line to Iron REPL",
		},
	},
}
