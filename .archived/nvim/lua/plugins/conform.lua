return {
	"stevearc/conform.nvim",
	lazy = true,
	cmd = { "ConformInfo" },
	opts = function()
		return {
			formatters_by_ft = {
				lua = { "stylua" },
				rust = { "rustfmt" },
			},
			default_format_opts = {
				lsp_format = "fallback",
			},
			format_on_save = { timeout_ms = 500 },
		}
	end,
}
