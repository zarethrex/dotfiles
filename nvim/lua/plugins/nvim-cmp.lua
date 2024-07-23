return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		{
			"Saecki/crates.nvim",
			event = { "BufRead Cargo.toml" },
			opts = {
				completion = {
					cmp = { enabled = true },
				},
			},
		},
	},
	opts = function(_, opts)
		opts.auto_brackets = opts.auto_brackets or {}
		table.insert(opts.auto_brackets, "python")
		opts.sources = opts.sources or {}
		table.insert(opts.sources, { name = "crates" })
		table.insert(opts.sources, { name = "git" })
	end,
}
