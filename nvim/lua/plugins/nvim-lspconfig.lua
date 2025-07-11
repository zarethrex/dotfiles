-- Function to check if the Sourcery config file exists
local function has_sourcery_config()
	local cwd = vim.fn.getcwd() -- Get the current working directory
	local config_path = cwd .. "/" .. ".sourcery.yaml"
	return vim.fn.filereadable(config_path) == 1 -- Check if the file is readable
end

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"someone-stole-my-name/yaml-companion.nvim",
	},
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
		require("lspconfig").ruff.setup({})
		require("lspconfig").dockerls.setup({})
		require("lspconfig").jinja_lsp.setup({})
		require("lspconfig").gh_actions_ls.setup({})
		local yaml_companion = require("yaml-companion")
		local schemastore_schemas = require("schemastore").yaml.schemas({
			select = {
				"kustomization.yaml",
				"GitHub Workflow",
			},
		})

		local custom_schemas = {
			["https://raw.githubusercontent.com/ansible/molecule/main/src/molecule/data/molecule.json"] = "molecule.yml",
			["https://raw.githubusercontent.com/ansible/ansible-lint/refs/heads/main/src/ansiblelint/schemas/requirements.json"] = "requirements.yml",
			["https://raw.githubusercontent.com/ansible/ansible-lint/refs/heads/main/src/ansiblelint/schemas/galaxy.json"] = "galaxy.yml",
			["https://raw.githubusercontent.com/ansible/ansible-lint/refs/heads/main/src/ansiblelint/schemas/meta-runtime.json"] = "**/meta/runtime.yml",
			["https://raw.githubusercontent.com/ansible/ansible-lint/refs/heads/main/src/ansiblelint/schemas/meta.json"] = "**/meta/main.yml",
		}

		local combined_schemas = vim.tbl_deep_extend("force", {}, schemastore_schemas, custom_schemas)

		require("lspconfig").yamlls.setup(yaml_companion.setup({
			-- Match Kubernetes schemas automatically
			builtin_matchers = {
				kubernetes = { enabled = true },
			},

			-- Optional schemas for :Telescope yaml_schema
			schemas = {
				{
					name = "Argo CD Application",
					uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json",
				},
				{
					name = "SealedSecret",
					uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/bitnami.com/sealedsecret_v1alpha1.json",
				},
				{
					name = "Kustomization",
					uri = "https://json.schemastore.org/kustomization.json",
				},
				{
					name = "GitHub Workflow",
					uri = "https://json.schemastore.org/github-workflow.json",
				},
				{
					name = "Ansible Molecule Scenario Config",
					uri = "https://raw.githubusercontent.com/ansible-community/molecule/main/src/molecule/data/molecule.json",
				},
				{
					name = "Ansible Requirements File",
					uri = "https://raw.githubusercontent.com/ansible/ansible-lint/refs/heads/main/src/ansiblelint/schemas/requirements.json",
				},
				{
					name = "Ansible Galaxy File",
					uri = "https://raw.githubusercontent.com/ansible/ansible-lint/refs/heads/main/src/ansiblelint/schemas/galaxy.json",
				},
				{
					name = "Ansible Meta Runtime File",
					uri = "https://raw.githubusercontent.com/ansible/ansible-lint/refs/heads/main/src/ansiblelint/schemas/meta-runtime.json",
				},
				{
					name = "Ansible Meta File",
					uri = "https://raw.githubusercontent.com/ansible/ansible-lint/refs/heads/main/src/ansiblelint/schemas/meta.json",
				},
			},

			lspconfig = {
				settings = {
					yaml = {
						validate = true,
						schemaStore = {
							enable = false,
							url = "",
						},
						completion = true,
						hover = true,
						schemas = combined_schemas,
					},
				},
			},
		}))

		require("telescope").load_extension("yaml_schema")
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
				return filename == "docker-compose.yaml" or filename == "docker-compose.yml"
			end,
		})
		require("lspconfig").taplo.setup({
			filetypes = { "toml" },
			settings = {
				evenBetterToml = {
					schema = {
						associations = {
							{
								-- Glob pattern to match your TOML file(s)
								pattern = "simvue.toml", -- or "**/myconfig.toml"
								uri = "https://raw.githubusercontent.com/simvue-io/python-api/refs/heads/v2.1/simvue/config/simvue_config_schema.json",
							},
						},
						enabled = true,
					},
				},
			},
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
			terraformls = {},
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
			["gh-actions"] = {
				filetypes = { "yaml.github", "yaml.gha" },
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
		},
	},
}
