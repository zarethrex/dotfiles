return {
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			local home = vim.env.HOME

			-- Ensure structure exists
			opts.servers = opts.servers or {}
			opts.servers.yamlls = opts.servers.yamlls or {}
			opts.servers.yamlls.settings = opts.servers.yamlls.settings or {}
			opts.servers.yamlls.settings.yaml = opts.servers.yamlls.settings.yaml or {}

			-- ✅ Extend ansible-language-server config
			opts.servers.ansiblels = vim.tbl_deep_extend("force", opts.servers.ansiblels or {}, {
				filetypes = { "yaml.ansible" },
			})

			local yaml = opts.servers.yamlls.settings.yaml

			-- Disable built-in SchemaStore (we control it)
			yaml.schemaStore = {
				enable = false,
				url = "",
			}

			yaml.validate = true
			yaml.completion = true
			yaml.hover = true

			-- ✅ 1. Pull selected schemas from schemastore.nvim
			local schemastore_schemas = require("schemastore").yaml.schemas({
				select = {
					"kustomization.yaml",
					"GitHub Workflow",
				},
			})

			-- ✅ 2. Your custom schemas (unchanged, just relocated)
			local custom_schemas = {
				["https://raw.githubusercontent.com/ansible/molecule/main/src/molecule/data/molecule.json"] = "molecule.yml",
				["https://raw.githubusercontent.com/ansible/ansible-lint/refs/heads/main/src/ansiblelint/schemas/requirements.json"] = "requirements.yml",
				["https://raw.githubusercontent.com/ansible/ansible-lint/refs/heads/main/src/ansiblelint/schemas/galaxy.json"] = "galaxy.yml",
				["https://raw.githubusercontent.com/ansible/ansible-lint/refs/heads/main/src/ansiblelint/schemas/meta-runtime.json"] = "**/meta/runtime.yml",
				["https://raw.githubusercontent.com/ansible/ansible-lint/refs/heads/main/src/ansiblelint/schemas/role-arg-spec.json"] = "**/meta/argument_specs.yml",
				["https://raw.githubusercontent.com/ansible/ansible-lint/refs/heads/main/src/ansiblelint/schemas/meta.json"] = "**/meta/main.yml",
				["https://raw.githubusercontent.com/ansible/ansible-lint/refs/heads/main/src/ansiblelint/schemas/tasks.json"] = "**/tasks/*.yml",
				["https://raw.githubusercontent.com/ansible/ansible-lint/refs/heads/main/src/ansiblelint/schemas/rulebook.json"] = "rulebook.yml",
				["https://raw.githubusercontent.com/ansible/ansible-lint/refs/heads/main/src/ansiblelint/schemas/execution-environment.json"] = "execution-environment.yml",
				["https://raw.githubusercontent.com/ansible/ansible-lint/refs/heads/main/src/ansiblelint/schemas/ansible-navigator.json"] = "ansible-navigator.yml",
				["https://raw.githubusercontent.com/ansible/ansible-lint/refs/heads/main/src/ansiblelint/schemas/playbook.json"] = "manifest.yml",
				["https://raw.githubusercontent.com/ansible/ansible-lint/refs/heads/main/src/ansiblelint/schemas/inventory.json"] = "inventory.yml",
				["https://raw.githubusercontent.com/citation-file-format/citation-file-format/refs/heads/main/schema.json"] = "CITATION.cff",
				["https://raw.githubusercontent.com/mfontanini/presenterm/master/config-file-schema.json"] = home
					.. "/.config/presenterm/config.yaml",
			}

			-- ✅ 3. Merge schemas (preserve everything)
			yaml.schemas = vim.tbl_deep_extend("force", yaml.schemas or {}, schemastore_schemas, custom_schemas)
		end,
	},

	-- ✅ yaml-companion stays separate and declarative
	{
		"someone-stole-my-name/yaml-companion.nvim",
		ft = { "yaml" },
		opts = {
			builtin_matchers = {
				kubernetes = { enabled = true },
			},
			schemas = {
				{
					name = "Argo CD Application",
					uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json",
				},
				{
					name = "SealedSecret",
					uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/bitnami.com/sealedsecret_v1alpha1.json",
				},
				{ name = "Kustomization", uri = "https://json.schemastore.org/kustomization.json" },
				{ name = "GitHub Workflow", uri = "https://json.schemastore.org/github-workflow.json" },
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
				{
					name = "Ansible Rulebook",
					uri = "https://raw.githubusercontent.com/ansible/ansible-lint/refs/heads/main/src/ansiblelint/schemas/rulebook.json",
				},
			},
		},
	},
}
