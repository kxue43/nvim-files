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

vim.lsp.config("basedpyright", {
  settings = {
    basedpyright = {
      disableOrganizeImports = true,
      analysis = {
        autoSearchPaths = false,
        typeCheckingMode = "basic",
        useTypingExtensions = true,
        inlayHints = {
          callArgumentNames = false,
        },
      },
    },
  },
})

-- Enable configured LSPs.
local servers = { "gopls", "lua_ls", "bashls", "basedpyright" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
