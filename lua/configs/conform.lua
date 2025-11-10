local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    go = { "gofmt" },
    yaml = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    python = { "black", timeout_ms = 10000 },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    ["javascript.jsx"] = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    ["typescript.tsx"] = { "prettier" },
  },

  default_format_opts = {
    lsp_format = "fallback",
  },

  format_on_save = {
    timeout_ms = 1000,
  },
}

return options
