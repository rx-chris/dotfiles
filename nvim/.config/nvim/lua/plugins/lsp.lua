return {

  -- Mason core (installer)
  {
    "mason-org/mason.nvim",
    opts = {},
  },

  -- Mason ↔ LSP bridge
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "clangd", "terraformls" }, -- add servers you need
      automatic_enable = true,
    },
    dependencies = { "mason-org/mason.nvim" },
  },

  -- Core LSP configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = { "mason-org/mason-lspconfig.nvim" },
    config = function()
      local lsp = vim.lsp

      -- Manually configure Lua LSP
      lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              globals = { "vim" }, -- recognize vim as global
            },
            workspace = {
              -- include all runtime files for autocomplete
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      lsp.enable("lua_ls")
    end,
  },
}
