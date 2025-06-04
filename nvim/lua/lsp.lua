vim.lsp.enable({ "lua", "rust", "ts", "eslint", "tailwindcss" })

vim.diagnostic.config({ severity_sort = true })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local opts = function(desc)
			return { desc = desc, buffer = ev.buf, silent = true }
		end

		local toggle_inlay_hints = function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		end

		local restart_lsp = function()
			vim.lsp.stop_client(vim.lsp.get_clients(), true)
			-- Hacky way because stop_client does not have a way to await.
			-- Can continuously check if it is stopped but seems equally hacky.
			vim.defer_fn(function()
				vim.cmd("edit")
			end, 500)
		end

		vim.keymap.set("n", "<C-,>", toggle_inlay_hints, opts("Toggle inlay hints"))
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code actions"))
		vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts("Rename symbol"))
		vim.keymap.set("n", "<leader>lr", restart_lsp, opts("Restart LSP"))
	end,
})

vim.keymap.set("n", "D", vim.diagnostic.open_float, { desc = "Hover Dianostics" })
vim.keymap.set("n", "<leader>li", ":silent checkhealth lsp<CR>", { desc = "LSP health check" })
