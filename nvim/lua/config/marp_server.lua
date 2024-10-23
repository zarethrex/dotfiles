-- Launch a Marp Server, solution provided by GPT4

-- marp_server.lua
local M = {}
local marp_job_id = nil -- Store Marp server job ID

-- Function to get the default browser command
local function get_default_browser_command()
	local os_name = vim.loop.os_uname().sysname

	if os_name == "Linux" then
		return "xdg-open" -- Common default browser command for Linux
	elseif os_name == "Darwin" then
		return "open" -- Default browser command for macOS
	else
		return "firefox" -- Fallback to Firefox for other systems
	end
end

-- Function to start the Marp server
function M.start_marp(port)
	local filepath = vim.fn.expand("%:p") -- Full path to the current file
	local directory = vim.fn.expand("%:p:h") -- Directory of the file
	local filename = vim.fn.expand("%:t") -- Filename (e.g., your_file.md)

	if marp_job_id then
		print("Marp server already running.")
		return
	end

	port = port or 8080 -- Default to port 8080 if no port is provided

	-- Start the Marp server for the directory
	marp_job_id = vim.fn.jobstart({ "marp", "--server", directory, "--port", tostring(port) }, { detach = true })

	if marp_job_id > 0 then
		print("Marp server started on port " .. port .. ".")
		-- Delay opening Firefox by 1 second (1000 milliseconds)
		vim.defer_fn(function()
			local url = "http://127.0.0.1:" .. port .. "/" .. filename
			local browser_cmd = get_default_browser_command()
			vim.cmd("silent! !" .. browser_cmd .. " " .. url)
		end, 1000) -- Delay in milliseconds
	else
		print("Failed to start Marp server.")
	end
end

-- Function to stop the Marp server
function M.stop_marp()
	if marp_job_id then
		vim.fn.jobstop(marp_job_id)
		marp_job_id = nil
		print("Marp server stopped.")
	else
		print("No Marp server running.")
	end
end

-- Autocmd to stop the server when the buffer is closed
vim.api.nvim_create_autocmd("BufWipeout", {
	pattern = "*.md",
	callback = function()
		if marp_job_id then
			vim.fn.jobstop(marp_job_id)
			marp_job_id = nil
			print("Marp server stopped on buffer close.")
		end
	end,
})

-- Autocmd to stop the server when Vim is closed
vim.api.nvim_create_autocmd("VimLeave", {
	callback = function()
		M.stop_marp() -- Call stop_marp function
	end,
})

-- Return the module
return M
