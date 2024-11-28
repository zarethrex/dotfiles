return {
	"hrsh7th/nvim-cmp",
	requires = {
		{ "kdheepak/cmp-latex-symbols" },
	},
	sources = {
		{
			name = "latex_symbols",
			option = {
				strategy = 0, -- mixed
			},
		},
	},
}
