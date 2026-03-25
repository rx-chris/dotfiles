return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	opts = {
		filesystem = {
			filtered_items = {
				hide_dotfiles = false,
				hide_gitignored = false, -- Optional: set to false to show gitignored files
				visible = true, -- Ensures this setting is active
			},
		},
	},
	keys = {
		{ "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle Neo-tree" },
	},
}
