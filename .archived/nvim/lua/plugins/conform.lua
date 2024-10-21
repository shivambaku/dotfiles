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
		}
	end,
	init = function()
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				require("conform").format({ bufnr = args.buf })
			end,
		})
	end,
}
