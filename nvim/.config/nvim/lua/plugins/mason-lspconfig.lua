return {
  "mason-org/mason-lspconfig.nvim",
  opts = {
    ensure_installed = { "clangd", "lua_ls" },  -- servers to auto-install
    automatic_enable = true,  -- auto-enable installed LSP servers
  },
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
  },
}

