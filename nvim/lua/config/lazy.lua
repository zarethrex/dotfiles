local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })
vim.fn.sign_define(
	"DapStopped",
	{ text = "", texthl = "DiagnosticSignWarn", linehl = "Visual", numhl = "DiagnosticSignWarn" }
)
vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#ffb400" })
vim.api.nvim_set_hl(0, "DapBreakpointRejected", { ctermbg = 0, fg = "#ff0000" })
vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#fffffe" })
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		-- add LazyVim and import its plugins
		{ "LazyVim/LazyVim", import = "lazyvim.plugins" },
		{ import = "lazyvim.plugins.extras.lsp.none-ls" },
		-- import/override with your plugins
		{ import = "plugins" },
	},
	defaults = {
		-- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
		-- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
		lazy = false,
		-- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
		-- have outdated releases, which may break your Neovim install.
		version = false, -- always use the latest git commit
		-- version = "*", -- try installing the latest stable version for plugins that support semver
	},
	install = { colorscheme = { "tokyonight", "habamax" } },
	checker = { enabled = true }, -- automatically check for plugin updates
	performance = {
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				"gzip",
				-- "matchit",
				-- "matchparen",
				-- "netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
require("colorizer").setup({})

local format = require("cmp_git.format")
local sort = require("cmp_git.sort")

require("cmp_git").setup({
	-- defaults
	filetypes = { "gitcommit", "octo" },
	remotes = { "upstream", "origin" }, -- in order of most to least prioritized
	enableRemoteUrlRewrites = false, -- enable git url rewrites, see https://git-scm.com/docs/git-config#Documentation/git-config.txt-urlltbasegtinsteadOf
	git = {
		commits = {
			limit = 100,
			sort_by = sort.git.commits,
			format = format.git.commits,
		},
	},
	github = {
		hosts = {}, -- list of private instances of github
		issues = {
			fields = { "title", "number", "body", "updatedAt", "state" },
			filter = "all", -- assigned, created, mentioned, subscribed, all, repos
			limit = 100,
			state = "open", -- open, closed, all
			sort_by = sort.github.issues,
			format = format.github.issues,
		},
		mentions = {
			limit = 100,
			sort_by = sort.github.mentions,
			format = format.github.mentions,
		},
		pull_requests = {
			fields = { "title", "number", "body", "updatedAt", "state" },
			limit = 100,
			state = "open", -- open, closed, merged, all
			sort_by = sort.github.pull_requests,
			format = format.github.pull_requests,
		},
	},
	gitlab = {
		hosts = {}, -- list of private instances of gitlab
		issues = {
			limit = 100,
			state = "opened", -- opened, closed, all
			sort_by = sort.gitlab.issues,
			format = format.gitlab.issues,
		},
		mentions = {
			limit = 100,
			sort_by = sort.gitlab.mentions,
			format = format.gitlab.mentions,
		},
		merge_requests = {
			limit = 100,
			state = "opened", -- opened, closed, locked, merged
			sort_by = sort.gitlab.merge_requests,
			format = format.gitlab.merge_requests,
		},
	},
	trigger_actions = {
		{
			debug_name = "git_commits",
			trigger_character = ":",
			action = function(sources, trigger_char, callback, params, git_info)
				return sources.git:get_commits(callback, params, trigger_char)
			end,
		},
		{
			debug_name = "gitlab_issues",
			trigger_character = "#",
			action = function(sources, trigger_char, callback, params, git_info)
				return sources.gitlab:get_issues(callback, git_info, trigger_char)
			end,
		},
		{
			debug_name = "gitlab_mentions",
			trigger_character = "@",
			action = function(sources, trigger_char, callback, params, git_info)
				return sources.gitlab:get_mentions(callback, git_info, trigger_char)
			end,
		},
		{
			debug_name = "gitlab_mrs",
			trigger_character = "!",
			action = function(sources, trigger_char, callback, params, git_info)
				return sources.gitlab:get_merge_requests(callback, git_info, trigger_char)
			end,
		},
		{
			debug_name = "github_issues_and_pr",
			trigger_character = "#",
			action = function(sources, trigger_char, callback, params, git_info)
				return sources.github:get_issues_and_prs(callback, git_info, trigger_char)
			end,
		},
		{
			debug_name = "github_mentions",
			trigger_character = "@",
			action = function(sources, trigger_char, callback, params, git_info)
				return sources.github:get_mentions(callback, git_info, trigger_char)
			end,
		},
	},
})
