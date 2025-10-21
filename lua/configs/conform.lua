local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    gopls = { "gofmt" },
    json = { "prettier" },
    jsonc = { "prettier" },
    python = { "black" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
