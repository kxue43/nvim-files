local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    gopls = { "gofmt" },
    json = { "prettier" },
    jsonc = { "prettier" },
    python = { "black", timeout_ms = 10000 },
  },

  default_format_opts = {
    lsp_format = "fallback",
  },

  format_on_save = {
    timeout_ms = 1000,
  },
}

return options
