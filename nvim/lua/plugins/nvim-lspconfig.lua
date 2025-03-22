-- Function to check if the Sourcery config file exists
local function has_sourcery_config()
	local cwd = vim.fn.getcwd() -- Get the current working directory
	local config_path = cwd .. "/" .. ".sourcery.yaml"
	return vim.fn.filereadable(config_path) == 1 -- Check if the file is readable
end

return {
	"neovim/nvim-lspconfig",
	config = function()
		require("lspconfig").pyright.setup({
			file_types = { "python" },
			settings = {
				pyright = {
					-- Using Ruff's import organizer
					disableOrganizeImports = true,
				},
				python = {
					analysis = {
						-- Ignore all files for analysis to exclusively use Ruff for linting
						ignore = { "*" },
					},
				},
				mypy = {
					extraArgs = { "--ignore-missing-imports" },
				},
			},
		})
		require("lspconfig").rust_analyzer.setup({
			on_attach = function(client, bufnr)
				require("crates").show()
			end,
		})
		require("lspconfig").ruff.setup({
			filetypes = { "python" },
		})
		if has_sourcery_config() then
			if not vim.env.SOURCERY_AI_TOKEN then
				vim.notify("Environment variable SOURCERY_AI_TOKEN unset", vim.log.levels.ERROR)
				return
			end
			require("lspconfig").sourcery.setup({})
		end
		require("lspconfig").clangd.setup({
			filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
			cmd = {
				"clangd",
				"--offset-encoding=utf-16",
			},
		})
		require("lspconfig").julials.setup({
			filetypes = { "julia", "jl" },
		})
		require("lspconfig").ansiblels.setup({
			filetypes = { "yaml.ansible" },
		})
		require("lspconfig").docker_compose_language_service.setup({
			filetypes = { "yaml" },
			condition = function(utils)
				local filename = vim.fn.expand("%:t")
				return filename == "docker-compose.yaml"
			end,
		})
		require("lspconfig").taplo.setup({
			filetypes = { "toml" },
		})
		require("lspconfig").texlab.setup({})
		require("lspconfig").cmake.setup({})
		require("lspconfig").ruby_lsp.setup({
			filetypes = {
				"ruby",
			},
		})
	end,
	opts = {
		servers = {
			neocmake = {},
			marksman = {},
			dockerls = {},
			jsonls = {
				-- lazy-load schemastore when needed
				on_new_config = function(new_config)
					new_config.settings.json.schemas = new_config.settings.json.schemas or {}
					vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
				end,
				settings = {
					json = {
						format = {
							enable = true,
						},
						validate = { enable = true },
					},
				},
			},
			docker_compose_language_service = {},
			ruff = {
				cmd_env = { RUFF_TRACE = "messages" },
				init_options = {
					settings = {
						logLevel = "error",
					},
				},
				keys = {
					{
						"<leader>co",
						LazyVim.lsp.action["source.organizeImports"],
						desc = "Organize Imports",
					},
				},
			},
			ruff = {
				keys = {
					{
						"<leader>co",
						LazyVim.lsp.action["source.organizeImports"],
						desc = "Organize Imports",
					},
				},
			},
			ruby_lsp = {
				enabled = lsp == "ruby_lsp",
			},
			solargraph = {
				enabled = lsp == "solargraph",
			},
			rubocop = {
				enabled = formatter == "rubocop",
			},
			standardrb = {
				enabled = formatter == "standardrb",
			},
			sourcery = {
				default_config = {
					cmd = { "sourcery", "lsp" },
					filetypes = { "python" },
					init_options = {
						editor_version = "vim",
						extension_version = "vim.lsp",
						token = vim.env.SOURCERY_AI_TOKEN,
					},
					root_dir = function(fname)
						return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
					end,
					single_file_support = true,
				},
				on_new_config = function(new_config, _)
					if not new_config.init_options.token then
						local notify = vim.notify_once or vim.notify
						notify(
							"[lspconfig] The authentication token must be provided in config.init_options",
							vim.log.levels.ERROR
						)
					end
				end,
				docs = {
					description = [[
            https://github.com/sourcery-ai/sourcery
            
            Refactor Python instantly using the power of AI.
            
            It requires the initializationOptions param to be populated as shown below and will respond with the list of ServerCapabilities that it supports.
            
            init_options = {
                --- The Sourcery token for authenticating the user.
                --- This is retrieved from the Sourcery website and must be
                --- provided by each user. The extension must provide a
                --- configuration option for the user to provide this value.
                token = <YOUR_TOKEN>
            
                --- The extension's name and version as defined by the extension.
                extension_version = 'vim.lsp'
            
                --- The editor's name and version as defined by the editor.
                editor_version = 'vim'
            }
            ]],
				},
			},
			taplo = {
				keys = {
					{
						"K",
						function()
							if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
								require("crates").show_popup()
							else
								vim.lsp.buf.hover()
							end
						end,
						desc = "Show Crate Documentation",
					},
				},
			},
			yamlls = {
				-- Have to add this for yamlls to understand that we support line folding
				capabilities = {
					textDocument = {
						foldingRange = {
							dynamicRegistration = false,
							lineFoldingOnly = true,
						},
					},
				},
				-- lazy-load schemastore when needed
				on_new_config = function(new_config)
					new_config.settings.yaml.schemas = vim.tbl_deep_extend(
						"force",
						new_config.settings.yaml.schemas or {},
						require("schemastore").yaml.schemas()
					)
				end,
				settings = {
					redhat = { telemetry = { enabled = false } },
					yaml = {
						keyOrdering = false,
						format = {
							enable = true,
						},
						validate = true,
						schemaStore = {
							-- Must disable built-in schemaStore support to use
							-- schemas from SchemaStore.nvim plugin
							enable = false,
							-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
							url = "",
						},
					},
				},
			},
		},
		setup = {
			yamlls = function()
				-- Neovim < 0.10 does not have dynamic registration for formatting
				if vim.fn.has("nvim-0.10") == 0 then
					LazyVim.lsp.on_attach(function(client, _)
						client.server_capabilities.documentFormattingProvider = true
					end, "yamlls")
				end
			end,
		},
	},
}
