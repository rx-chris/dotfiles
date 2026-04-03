return {
	"nvim-telescope/telescope.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},

	keys = {
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
		{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
		{
			"<leader>fg",
			function()
				require("telescope.builtin").live_grep({
					additional_args = function()
						return { "--hidden", "--glob", "!.git/*" }
					end,
				})
			end,
			desc = "Live grep",
		},
	},

	config = function()
		require("telescope").setup({
			defaults = {
				file_ignore_patterns = { "^.git/" }, -- Optional: ignore git folder but show git files
			},
			pickers = {
				find_files = {
					hidden = true, -- Show hidden files (starting with .)
					no_ignore = true, -- Show files ignored by .gitignore
				},
			},
		})
	end,
}
