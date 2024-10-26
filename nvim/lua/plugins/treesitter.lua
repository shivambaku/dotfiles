return {
	"nvim-treesitter/nvim-treesitter",
	version = false,
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"lua",
				"rust",
			},
			sync_install = false,
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
		})

		-- Lowering the LSP priority so treesitter has higher priority.
		vim.highlight.priorities.semantic_tokens = 95
	end,
}
