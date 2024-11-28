return {
	"wintermute-cell/gitignore.nvim",
	config = function()
		require("gitignore")
	end,
	keys = {
		{
			"<leader>gi",
			function()
				require("gitignore").generate()
			end,
			"Generate .gitignore",
		},
	},
}
