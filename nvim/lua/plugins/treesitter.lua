return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      'nvim-treesitter/nvim-treesitter-context',
    },
    branch = "master",
    build = ":TSUpdate",
    -- Crucial: Treesitter should not be lazy-loaded to ensure highlighting works on startup
    lazy = false, 
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        -- Add your languages here
        ensure_installed = { 
          -- Core & Config
          "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline",
          
          -- C# (Your primary)
          "c_sharp",
          
          -- Python
          "python",
          
          -- Web Dev (JS/TS stack)
          "javascript",
          "typescript",
          "tsx",          -- Support for React/TypeScript files
          "css",
          "html",
          "json",
          "jsonc",        -- JSON with comments (used in VS Code configs)
          
          -- Other helpful web/scripting tools
          "bash",
          "yaml",
          "toml"
        },
        
        sync_install = false,
        auto_install = true,
        
        highlight = {
          enable = true,
          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Often causes double-highlighting, so keep it false unless you have a reason.
          additional_vim_regex_highlighting = false,
        },
        
        indent = {
          enable = true,
        },

        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<Leader>ss",
            node_incremental = "<Leader>si",
            scope_incremental = "<Leader>sc",
            node_decremental = "<Leader>sd",
          }
        }
      })
    end,
  },
}
