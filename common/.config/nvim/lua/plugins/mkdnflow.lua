return {
	"jakewvincent/mkdnflow.nvim",
	ft = "markdown",
	config = function()
		require("mkdnflow").setup({
			create_dirs = false,
			filetypes = {
				rmd = false,
			},
			modules = {
				backlinks = false,
				bib = false,
				buffers = false,
				conceal = false,
				foldtext = false,
				maps = false,
				notebook = false,
				templates = false,
			},
			path_resolution = {
				primary = "current",
				update_on_navigate = false,
			},
			links = {
				auto_create = false,
				transform_on_create = false,
			},
			to_do = {
				status_order = { "not_started", "complete" },
				status_propagation = {
					up = false,
					down = false,
				},
			},
			on_attach = function(buf)
				local function map(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, {
						buffer = buf,
						desc = desc,
						silent = true,
					})
				end

				map("n", "<leader>mm", ":Mkdnflow ", "Markdown: commands")
				map("n", "<leader>mr", "<Cmd>RenderMarkdown toggle<CR>", "Markdown: toggle rendering")
				map("n", "<leader>mp", "<Cmd>RenderMarkdown preview<CR>", "Markdown: preview")
				map("n", "<leader>mx", "<Cmd>MkdnToggleToDo<CR>", "Markdown: toggle checkbox")
				map("x", "<leader>mx", ":MkdnToggleToDo<CR>", "Markdown: toggle checkboxes")
				map("n", "<leader>mn", "<Cmd>MkdnUpdateNumbering<CR>", "Markdown: renumber list")

				map("n", "<leader>mtt", ":MkdnTable ", "Markdown table: create")
				map("n", "<leader>mtf", "<Cmd>MkdnTableFormat<CR>", "Markdown table: format")
				map("n", "<leader>mtn", "<Cmd>MkdnTableNextCell<CR>", "Markdown table: next cell")
				map("n", "<leader>mtp", "<Cmd>MkdnTablePrevCell<CR>", "Markdown table: previous cell")
				map("n", "<leader>mto", "<Cmd>MkdnTableNewRowBelow<CR>", "Markdown table: add row below")
				map("n", "<leader>mtO", "<Cmd>MkdnTableNewRowAbove<CR>", "Markdown table: add row above")
				map("n", "<leader>mtc", "<Cmd>MkdnTableNewColAfter<CR>", "Markdown table: add column after")
				map("n", "<leader>mtC", "<Cmd>MkdnTableNewColBefore<CR>", "Markdown table: add column before")
				map("n", "<leader>mtd", "<Cmd>MkdnTableDeleteRow<CR>", "Markdown table: delete row")
				map("n", "<leader>mtD", "<Cmd>MkdnTableDeleteCol<CR>", "Markdown table: delete column")

				map("n", "<leader>mlf", "<Cmd>MkdnFollowLink<CR>", "Markdown link: follow")
				map("n", "<leader>mlc", "<Cmd>MkdnCreateLink<CR>", "Markdown link: create")
				map("x", "<leader>mlc", ":MkdnCreateLink<CR>", "Markdown link: create")
				map("n", "<leader>mlp", "<Cmd>MkdnCreateLinkFromClipboard<CR>", "Markdown link: create from clipboard")
				map("x", "<leader>mlp", ":MkdnCreateLinkFromClipboard<CR>", "Markdown link: create from clipboard")
				map("n", "<leader>mld", "<Cmd>MkdnDestroyLink<CR>", "Markdown link: remove")

				map("n", "<leader>mhn", "<Cmd>MkdnNextHeading<CR>", "Markdown heading: next")
				map("n", "<leader>mhp", "<Cmd>MkdnPrevHeading<CR>", "Markdown heading: previous")
				map("n", "<leader>mhi", "<Cmd>MkdnIncreaseHeading<CR>", "Markdown heading: increase")
				map("n", "<leader>mhd", "<Cmd>MkdnDecreaseHeading<CR>", "Markdown heading: decrease")
			end,
		})
	end,
}
