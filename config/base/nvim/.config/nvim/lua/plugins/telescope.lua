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
		{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
		{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
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
