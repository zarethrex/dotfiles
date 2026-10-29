return {
	"Bishop-Fox/colorblocks.nvim",
	config = function()
		require("colorblocks").setup({
			symbol = "███",
			virt_text_pos = "eol",
			mode = "fg",
			section = { "S", "  ", "The color is: ", "H" },
			filetypes = { "lua", "css" },
		})
	end,
}
