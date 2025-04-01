vim.diagnostic.config({ severity_sort = true })

vim.lsp.enable({ "lua-language-server", "rust-analyzer" })

vim.lsp.config["lua-language-server"] = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json" },
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
}

vim.lsp.config["rust-analyzer"] = {
	cmd = { "rust-analyzer" },
	filetypes = { "rs", "rust" },
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
}

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local opts = function(desc)
			return { desc = desc, buffer = ev.buf }
		end

		local toggle_inlay_hints = function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		end

		vim.keymap.set("n", "D", vim.diagnostic.open_float, opts("Hover Dianostics"))
		vim.keymap.set("n", "<C-,>", toggle_inlay_hints, opts("Toggle inlay hints"))
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code actions"))
		vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts("Rename symbol"))
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
	end,
})
