local M = {}

function M.setup()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),

    callback = function(event)
      local map = function(keys, func, desc, mode)
        mode = mode or "n"
        vim.keymap.set(mode, keys, func, {
          buffer = event.buf,
          desc = "LSP: " .. desc,
        })
      end

      map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
      map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
      map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

      local client = vim.lsp.get_client_by_id(event.data.client_id)

      if client and client:supports_method("textDocument/documentHighlight") then
        local group = vim.api.nvim_create_augroup("user-lsp-highlight", {})

        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = event.buf,
          group = group,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = event.buf,
          group = group,
          callback = vim.lsp.buf.clear_references,
        })
      end

      if client and client:supports_method("textDocument/inlayHint") then
        map("<leader>th", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
        end, "[T]oggle Inlay [H]ints")
      end
    end,
  })
end

return M
