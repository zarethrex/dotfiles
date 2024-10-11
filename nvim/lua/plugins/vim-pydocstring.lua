return {
	"heavenshell/vim-pydocstring",
	ft = "python",
	build = "make install",
	config = function()
		vim.g.pydocstring_formatter = "numpy"
	end,
	keys = {
		{ "gcd", ":Pydocstring<CR>", mode = "n", desc = "Create Python docstring" },
	},
}
