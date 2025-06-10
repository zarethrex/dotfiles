vim.filetype.add({
	["**/tasks/*.yml"] = "yaml.ansible",
	["**/molecule/*/{converge,verify,create,destroy}.yml"] = "yaml.ansible",
	["playbook.yml"] = "yaml.ansible",
	["*Containerfile"] = "dockerfile",
})
