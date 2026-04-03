return {
	"saghen/blink.cmp",
	event = "VimEnter",
	version = "1.*",
	dependencies = {
		-- Snippet engine
		{
			"L3MON4D3/LuaSnip",
			version = "2.*",
			build = "cargo build --release",
			opts = {},
			dependencies = {
				-- Premade snippet collection
				{
					"rafamadriz/friendly-snippets",
					config = function()
						require("luasnip.loaders.from_vscode").lazy_load()
					end,
				},
			},
		},
	},
	opts = {
		keymap = {
			preset = "super-tab", -- standard completion keymaps
		},
		appearance = {
			nerd_font_variant = "mono", -- aligns icons nicely
		},
		completion = {
			documentation = { auto_show = true },
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
			providers = {
				buffer = {
					opts = {
						get_bufnrs = function()
							return vim.api.nvim_list_bufs()
						end,
					},
				},
			},
		},
		snippets = { preset = "luasnip" },
		fuzzy = { implementation = "prefer_rust_with_warning" },
		signature = { enabled = true },
	},
}
