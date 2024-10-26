return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
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
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Hover"))
				vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts("Go to next diagnostics"))
				vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts("Go to previous diagnositcs"))
				vim.keymap.set("n", "<C-,>", function()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
				end, opts("Toggle inlay hints"))
			end,
		})

		local cmp = require("cmp")
		local cmp_select = { behavior = cmp.SelectBehavior.Select }
		cmp.setup({
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<Tab>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "buffer" },
			}),
		})

		cmp.setup.cmdline("/", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})

		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{
					name = "cmdline",
					option = {
						ignore_cmds = { "Man", "!" },
					},
				},
			}),
		})

		local lspconfig = require("lspconfig")
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
}
