local marp = require("config.marp_server")

-- Define the :MarpStart command
vim.api.nvim_create_user_command("MarpStart", function(opts)
	local port = tonumber(opts.args)
	marp.start_marp(port)
end, {
	nargs = "?",
})

-- Define the :MarpStop command
vim.api.nvim_create_user_command("MarpStop", function()
	marp.stop_marp()
end, {})
