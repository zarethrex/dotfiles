return {
	"michaelb/sniprun",
	branch = "master",
	build = "sh install.sh",
	keys = {
		{ "<leader>rc", "<cmd>SnipRun<CR>", "Run current code" },
		{ "<leader>rr", "<cmd>SnipReset<CR>", "Rest code runner" },
		{ "<leader>rq", "<cmd>SnipClose<CR>", "Clear code runner text" },
	},
}
