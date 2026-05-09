return {
	{
		dir = "~/Documents/Projects/Personal/fire-and-forget.nvim/",
		config = function()
			require("faf").setup({
				model = "openai/gpt-5.5-fast",
				variant = "high",
			})
		end,
	},
}
