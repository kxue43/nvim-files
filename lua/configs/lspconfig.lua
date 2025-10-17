require("nvchad.configs.lspconfig").defaults()

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

local servers = { "gopls", "lua_ls", "html", "cssls" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
