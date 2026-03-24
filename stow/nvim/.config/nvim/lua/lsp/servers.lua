local servers = {

  -- Web
  ts_ls = {},
  html = {},
  cssls = {},
  jsonls = {},

  -- Python
  pyright = {},

  -- Ruby
  ruby_lsp = {},

  -- C#
  omnisharp = {},

  -- Lua
  lua_ls = {
    on_init = function(client)
      if client.workspace_folders then
        local path = client.workspace_folders[1].name

        if path ~= vim.fn.stdpath('config')
          and (vim.uv.fs_stat(path .. '/.luarc.json')
          or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
          return
        end
      end

      client.config.settings.Lua =
        vim.tbl_deep_extend('force', client.config.settings.Lua, {

          runtime = {
            version = 'LuaJIT',
            path = { 'lua/?.lua', 'lua/?/init.lua' },
          },

          workspace = {
            checkThirdParty = false,
            library = vim.tbl_extend(
              'force',
              vim.api.nvim_get_runtime_file('', true),
              {
                '${3rd}/luv/library',
                '${3rd}/busted/library',
              }
            ),
          },
        })
    end,

    settings = {
      Lua = {},
    },
  },
}

return servers
