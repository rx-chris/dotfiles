--------------------------------------------------
-- Leader Keys (must be set before lazy loads)
--------------------------------------------------
vim.g.mapleader = " " -- Set <leader> key to Space
vim.g.maplocalleader = "\\" -- Set <localleader> key to backslash

--------------------------------------------------
-- UI
--------------------------------------------------
vim.opt.number = true -- Show absolute line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.termguicolors = true -- Enable 24-bit RGB colors in terminal
vim.opt.wrap = false -- Disable line wrapping
vim.opt.scrolloff = 8 -- Keep 8 lines visible above/below cursor

--------------------------------------------------
-- Window Splits
--------------------------------------------------
vim.opt.splitbelow = true -- Horizontal splits open below
vim.opt.splitright = true -- Vertical splits open to the right
vim.opt.inccommand = "split" -- Live preview of :substitute in split window

--------------------------------------------------
-- Editing Behavior
--------------------------------------------------
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.shiftwidth = 2 -- Indentation width for >> and <<
vim.opt.tabstop = 2 -- Number of spaces a tab character represents
vim.opt.softtabstop = 2 -- Spaces inserted when pressing <Tab> in insert mode
vim.opt.virtualedit = "block" -- Allow cursor past end of line in visual block mode

--------------------------------------------------
-- Search
--------------------------------------------------
vim.opt.ignorecase = true -- Case-insensitive searching
vim.opt.smartcase = true -- Case-sensitive if search contains capital letters

-- Highlight search matches
vim.opt.hlsearch = true
vim.opt.incsearch = true

--------------------------------------------------
-- Performance
--------------------------------------------------
vim.opt.updatetime = 250 -- Faster update time for events
vim.opt.undofile = true -- Persistent undo history

--------------------------------------------------
-- Clipboard
--------------------------------------------------
-- Only yank to system clipboard, 'd' and 'c' remain local (default behavior)
vim.keymap.set("n", "y", '"+y', { noremap = true })
vim.keymap.set("v", "y", '"+y', { noremap = true })
vim.keymap.set("n", "Y", '"+Y', { noremap = true })

--------------------------------------------------
-- Diagnostics
--------------------------------------------------
vim.diagnostic.config({
	virtual_lines = true,
})
