vim.lsp.enable({
	"lua",
	"rust",
	"eslint",
	"tailwindcss",
	"html",
	"ruff",
	"python",
	"ts",
	"vue",
	"toml",
	"elixir",
	"roslyn_ls",
})

vim.diagnostic.config({ severity_sort = true })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local opts = function(desc)
			return { desc = desc, buf = ev.buf, silent = true }
		end

		local toggle_inlay_hints = function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		end

		vim.keymap.set("n", "<C-,>", toggle_inlay_hints, opts("Toggle inlay hints"))
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code actions"))
		vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts("Rename symbol"))
		vim.keymap.set("n", "<leader>lr", "<Cmd>lsp restart<CR>", opts("Restart LSP"))
	end,
})

vim.keymap.set("n", "D", vim.diagnostic.open_float, { desc = "Hover Dianostics" })
vim.keymap.set("n", "<leader>li", ":silent checkhealth lsp<CR>", { desc = "LSP health check" })
