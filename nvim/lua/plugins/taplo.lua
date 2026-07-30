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
								},
							},
						},
					},
				},
			},
		},
	},
}
