return {
	"kawre/leetcode.nvim",
	build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
	dependencies = {
		-- include a picker of your choice, see picker section for more details
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	opts = {
		lang = "rust",

		injector = {
			["rust"] = {
				before = { "#[allow(dead_code)]", "fn main(){}", "#[allow(dead_code)]", "struct Solution;" },
			},
		},

		hooks = {
			["question_enter"] = {
				function(question)
					if question.lang ~= "rust" then
						return
					end
					local problem_dir = vim.fn.stdpath("data") .. "/leetcode/Cargo.toml"
					local content = [[
              [package]
              name = "leetcode"
              edition = "2024"
                                                                                                     
              [lib]
              name = "%s"
              path = "%s"
                                                                                                     
              [dependencies]
              rand = "0.8"
              regex = "1"
              itertools = "0.14.0"
            ]]
					local file = io.open(problem_dir, "w")
					if file then
						local formatted = (content:gsub(" +", "")):format(question.q.frontend_id, question:path())
						file:write(formatted)
						file:close()
					else
						print("Failed to open file: " .. problem_dir)
					end
				end,
			},
		},
	},
	keys = {
		{ "<leader>lq", "<cmd>Leet<cr>", desc = "Leetcode Menu" },
		{ "<leader>ll", "<cmd>Leet list<cr>", desc = "Leetcode List" },
		{ "<leader>lt", "<cmd>Leet run<cr>", desc = "Leetcode Run" },
		{ "<leader>lc", "<cmd>Leet console<cr>", desc = "Leetcode Console" },
		{ "<leader>ls", "<cmd>Leet submit<cr>", desc = "Leetcode Submit" },
		{ "<leader>ld", "<cmd>Leet desc<cr>", desc = "Leetcode Description" },
		{ "<leader>lo", "<cmd>Leet open<cr>", desc = "Leetcode Open in Browser" },
	},
}
