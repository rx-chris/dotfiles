-- =========================================================
-- Leader Keys (must be set before lazy loads)
-- =========================================================
vim.g.mapleader = " " -- Space as global leader
vim.g.maplocalleader = "\\" -- Backslash as local leader

-- Custom map function that includes opts and desc
local map = function(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
end

-- =========================================================
-- General Keymaps
-- =========================================================
map("n", "<leader>a", "ggVG", "Select all text")
map("n", "<leader>f", function()
	vim.lsp.buf.format({ async = true })
end, "Format buffer")
map("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>//gI<Left><Left><Left>", "Replace word under cursor")

-- =========================================================
-- Save / Quit
-- =========================================================
map("n", "<leader>w", ":w<CR>", "Save file")
map("n", "<leader>q", ":q<CR>", "Quit")
map("n", "<leader>x", ":x<CR>", "Save & quit")

-- =========================================================
-- Search
-- =========================================================
-- Nicer jump to search match
map("n", "n", "nzzzv", "Jump to next match and center screen")
map("n", "N", "Nzzzv", "Jump to previous match and center screen")

-- Clear search highlight
map("n", "<Esc><Esc>", ":nohlsearch<CR>", "Clear search highlight")

-- =========================================================
-- Buffer Navigation
-- =========================================================
map("n", "<leader>bn", ":bnext<CR>", "Next buffer")
map("n", "<leader>bp", ":bprevious<CR>", "Previous buffer")
map("n", "<leader>bd", ":bdelete<CR>", "Delete buffer")

-- =========================================================
-- Window Navigation
-- =========================================================
map("n", "<C-h>", "<C-w>h", "Move to left window")
map("n", "<C-j>", "<C-w>j", "Move to below window")
map("n", "<C-k>", "<C-w>k", "Move to above window")
map("n", "<C-l>", "<C-w>l", "Move to right window")

-- Split resizing
map("n", "<C-Up>", ":resize +2<CR>", "Increase height")
map("n", "<C-Down>", ":resize -2<CR>", "Decrease height")
map("n", "<C-Left>", ":vertical resize -2<CR>", "Decrease width")
map("n", "<C-Right>", ":vertical resize +2<CR>", "Increase width")

-- =========================================================
-- Visual Mode Enhancements
-- =========================================================
map("v", "<", "<gv", "Stay in indent mode (left)")
map("v", ">", ">gv", "Stay in indent mode (right)")

-- Move current line in normal mode
map("n", "<A-j>", ":m .+1<CR>==", "Move line down")
map("n", "<A-k>", ":m .-2<CR>==", "Move line up")

-- Move selected lines in visual mode
map("v", "<A-j>", ":m '>+1<CR>gv=gv", "Move selection down")
map("v", "<A-k>", ":m '<-2<CR>gv=gv", "Move selection up")

-- Move current line while staying in insert mode
map("i", "<A-j>", "<Esc>:m .+1<CR>==gi", "Move line down in insert mode")
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi", "Move line up in insert mode")

-- =========================================================
-- Insert Mode Enhancements
-- =========================================================
-- exit insert mode
map("i", "jk", "<ESC>", "Exit insert mode (jk)")
map("i", "kj", "<ESC>", "Exit insert mode (kj)")
map("i", "JK", "<ESC>", "Exit insert mode (JK)")
map("i", "KJ", "<ESC>", "Exit insert mode (KJ)")

-- Highlight text
map("i", "<S-Left>", "<Esc>v<Left>", "Highlight text towards the left")
map("i", "<S-Right>", "<Esc>v<Right>", "Highlight text towards the right")
