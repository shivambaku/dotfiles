return {
	"saghen/blink.cmp",
	version = "1.*",
	event = { "InsertEnter", "CmdlineEnter" },
	config = function()
		require("blink.cmp").setup({
			keymap = {
				preset = "super-tab",
				["<A-y>"] = require("minuet").make_blink_map(),
			},
			sources = {
				default = { "lsp", "buffer", "snippets", "path", "minuet" },
				per_filetype = { sql = { "dadbod" } },
				providers = {
					dadbod = { module = "vim_dadbod_completion.blink" },
					minuet = {
						name = "minuet",
						module = "minuet.blink",
						score_offset = 8,
					},
				},
			},
			fuzzy = { implementation = "rust" },
			completion = { trigger = { prefetch_on_insert = false } },
		})
	end,
}
