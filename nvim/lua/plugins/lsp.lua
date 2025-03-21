return {
	-- Auto formatting
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					rust = { "rustfmt" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_format = "fallback",
				},
			})
		end,
	},
	-- LSP
	{
		"neovim/nvim-lspconfig",
		ft = { "rust", "lua" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			require("mason").setup()
			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						require("lspconfig")[server_name].setup({
							capabilities = capabilities,
						})
					end,
				},
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("Lsp", {}),
				callback = function(e)
					local opts = function(desc)
						return { desc = desc, buffer = e.buf }
					end
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code actions"))
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
					vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts("Rename symbol"))
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Hover"))
					vim.keymap.set("n", "D", function()
						vim.diagnostic.open_float()
						vim.diagnostic.open_float()
					end, opts("Hover Dianostics"))
					vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts("Go to next diagnostics"))
					vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts("Go to previous diagnositcs"))
					vim.keymap.set("n", "<C-,>", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
					end, opts("Toggle inlay hints"))
				end,
			})

			-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
			local lspconfig = require("lspconfig")

			lspconfig.lua_ls.setup({
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})

			lspconfig.rust_analyzer.setup({
				settings = {
					["rust-analyzer"] = {
						check = {
							command = "clippy",
							extraArgs = {
								"--",
								"--no-deps",
								"-Wclippy::all",
								"-Wclippy::nursery",
							},
						},
					},
				},
			})
		end,
	},
}
