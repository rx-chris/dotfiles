-- show line numbering
vim.opt.number = true

-- show relative line number from cursor
vim.opt.relativenumber = true

-- set horizontal splits to below
vim.opt.splitbelow = true

-- set vertical splits to the right
vim.opt.splitright = true

-- disable word wrap
vim.opt.wrap = false

-- expand tabs into spaces with spacing of 2
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- every time I yank, delete, or change text, put it in the System Clipboard
vim.opt.clipboard = "unnamedplus"

-- maintains scroll cursor focus to center of screen
vim.opt.scrolloff = 999

-- remove block restriction in visual block mode
vim.opt.virtualedit = "block"

-- opens preview in split window for certain commands
vim.opt.inccommand = "split"

-- ignore letter casing, useful for plugin commands which uses Pascal case
vim.opt.ignorecase = true

-- enables 24 bit colour in terminal
vim.opt.termguicolors = true

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
