require("nvchad.configs.lspconfig").defaults()

-- Add own LSP configs here.
vim.lsp.config("gopls", {
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
    },
  },
})

-- Enable configured LSPs.
local servers = { "gopls", "lua_ls", "bashls" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
