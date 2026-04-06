-- overrides clipboard for Proot/Termux
vim.g.clipboard = {
	name = "termux-clipboard",
	copy = {
		["+"] = "termux-clipboard-set",
		["*"] = "termux-clipboard-set",
	},
	paste = {
		["+"] = "termux-clipboard-get",
		["*"] = "termux-clipboard-get",
	},
	cache_enabled = 0,
}
