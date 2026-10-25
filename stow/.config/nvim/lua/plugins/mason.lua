return {
	"williamboman/mason.nvim",
	dependencies = {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		require("mason").setup({
			registries = {
				"github:mason-org/mason-registry",
				"github:Crashdummyy/mason-registry",
			},
		})

		require("mason-tool-installer").setup({
			ensure_installed = {
				"basedpyright",
				"bash-language-server",
				"codelldb",
				"elixir-ls",
				"eslint-lsp",
				"html-lsp",
				"lua-language-server",
				"netcoredbg",
				"prettierd",
				"roslyn",
				"ruff",
				"rust-analyzer",
				"stylua",
				"tailwindcss-language-server",
				"taplo",
				"vtsls",
				"vue-language-server",
			},
		})
	end,
}
