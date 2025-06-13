vim.filetype.add({
	pattern = {
		[".*/roles/.*/tasks/.*%.yml"] = "yaml.ansible",
		[".*/molecule/.*/converge.yml"] = "yaml.ansible",
		[".*/molecule/.*/verify.yml"] = "yaml.ansible",
		[".*/molecule/.*/create.yml"] = "yaml.ansible",
		[".*/molecule/.*/destroy.yml"] = "yaml.ansible",
		[".%.jinja"] = "jinja",
		[".%.jinja2"] = "jinja",
		["playbook.yml"] = "yaml.ansible",
		["*Containerfile"] = "dockerfile",
	},
})
