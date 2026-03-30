return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		-- {
		-- 	"JoosepAlviste/nvim-ts-context-commentstring",
		-- 	lazy = true,
		-- },
	},
	config = function()
		require("nvim-treesitter").install({
			"bash",
			"c",
			"cpp",
			"gitcommit",
			"go",
			"graphql",
			"html",
			"java",
			"javascript",
			"json",
			"json5",
			"jsonc",
			"lua",
			"markdown",
			"markdown_inline",
			"python",
			"query",
			"regex",
			"rust",
			"scss",
			"toml",
			"tsx",
			"typescript",
			"vim",
			"vimdoc",
			"yaml",
		})

		-- Lowering the LSP priority so treesitter has higher priority.
		vim.highlight.priorities.semantic_tokens = 95
	end,
}
