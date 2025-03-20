return {
	"yetone/avante.nvim",
	enabled = false,
	event = "VeryLazy",
	version = false,
	build = "make",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
	config = function()
		require("avante").setup({
			provider = "ollama",
			ollama = {
				model = "qwen2.5-coder:14b-instruct-q6_K",
			},
			behaviour = {
				enable_cursor_planning_mode = true,
			},
		})
	end,
}
