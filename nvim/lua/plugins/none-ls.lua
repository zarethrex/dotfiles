return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		local lfs = require("lfs")

		-- Function to get the Python executable from the .venv directory
		local function get_venv_python_bin()
			local venv_python
			if package.config:sub(1, 1) == "\\" then
				return ".venv\\Scripts\\"
			else
				return ".venv/bin" -- Unix-like systems
			end
		end

		null_ls.setup({
			sources = {
				null_ls.builtins.diagnostics.mypy.with({
					prefer_local = get_venv_python_bin(),
				}),
				null_ls.builtins.diagnostics.cppcheck,
				null_ls.builtins.diagnostics.cpplint,
				null_ls.builtins.formatting.ruff,
			},
		})
	end,
}
