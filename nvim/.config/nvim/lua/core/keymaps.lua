-- =========================================================
-- Keymaps
-- =========================================================

-- Leader Keys (must be set before lazy loads)
vim.g.mapleader = " "        -- Space as global leader
vim.g.maplocalleader = "\\"  -- Backslash as local leader

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- =========================================================
-- Save / Quit
-- =========================================================
map("n", "<leader>w", ":w<CR>", opts)   -- Save file
map("n", "<leader>q", ":q<CR>", opts)   -- Quit
map("n", "<leader>x", ":x<CR>", opts)   -- Save & quit

-- =========================================================
-- Search
-- =========================================================
map("n", "<leader>h", ":nohlsearch<CR>", opts) -- Clear search highlight

-- =========================================================
-- Buffer Navigation
-- =========================================================
map("n", "<leader>bn", ":bnext<CR>", opts)     -- Next buffer
map("n", "<leader>bp", ":bprevious<CR>", opts) -- Previous buffer
map("n", "<leader>bd", ":bdelete<CR>", opts)   -- Delete buffer

-- =========================================================
-- Window Navigation
-- =========================================================
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Split resizing
map("n", "<C-Up>", ":resize +2<CR>", opts)
map("n", "<C-Down>", ":resize -2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- =========================================================
-- Visual Mode Enhancements
-- =========================================================
map("v", "<", "<gv", opts)      -- Stay in indent mode
map("v", ">", ">gv", opts)
map("v", "<A-j>", ":m '>+1<CR>gv=gv", opts) -- Move selected lines down
map("v", "<A-k>", ":m '<-2<CR>gv=gv", opts) -- Move selected lines up

-- =========================================================
-- Insert Mode Enhancements
-- =========================================================
map("i", "jk", "<ESC>", opts)  -- Press jk to exit insert mode
map("i", "kj", "<ESC>", opts)

-- =========================================================
-- Other Useful Shortcuts
-- =========================================================
map("n", "<C-a>", "ggVG", opts) -- Select all text in the buffer

-- manual formatting
vim.keymap.set("n", "<leader>f", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format buffer" })
