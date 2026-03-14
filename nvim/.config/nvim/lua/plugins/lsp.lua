return {
  'neovim/nvim-lspconfig',

  dependencies = {
    {
      'mason-org/mason.nvim',
      opts = {},
    },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    { 'j-hui/fidget.nvim', opts = {} },

    'saghen/blink.cmp',
  },

  config = function()
    require('lsp.attach').setup()

    local capabilities = require("lsp.capabilities")

    local servers = require('lsp.servers')

    local ensure_installed = vim.tbl_keys(servers)
    vim.list_extend(ensure_installed, { 'stylua' })

    require('mason-tool-installer').setup({
      ensure_installed = ensure_installed,
    })

    for name, config in pairs(servers) do
      config.capabilities = capabilities
      vim.lsp.config(name, config)
      vim.lsp.enable(name)
    end
  end,
}
