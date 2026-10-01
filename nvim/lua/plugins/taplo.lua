return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				taplo = {
					settings = {
						evenBetterToml = {
							schema = {
								associations = {
									["(.*)simvue\\.toml$"] = "https://raw.githubusercontent.com/simvue-io/python-api/refs/heads/dev/simvue/config/simvue_config_schema.json",
									["(.*)prek\\.toml$"] = "https://raw.githubusercontent.com/j178/prek/refs/tags/v0.5.4/prek.schema.json",
									["(.*)pyproject\\.toml$"] = "https://raw.githubusercontent.com/SchemaStore/schemastore/refs/heads/master/src/schemas/json/pyproject.json",
								},
							},
						},
					},
				},
			},
		},
	},
}
