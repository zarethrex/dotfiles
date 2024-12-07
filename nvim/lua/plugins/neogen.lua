return {
	"danymat/neogen",
	config = function()
		require("neogen").setup({
			languages = {
				python = {
					template = {
						annotation_convention = "numpydoc",
					},
				},
			},
		})
	end,
}
