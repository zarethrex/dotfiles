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
			},
		})
		require("lspconfig").ruff_lsp.setup({
			filetypes = { "python" },
		})
		require("lspconfig").ansiblels.setup({
			filetypes = { "yaml.ansible" },
		})
		require("lspconfig").taplo.setup({
			filetypes = { "toml" },
		})
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
			ruff_lsp = {
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
