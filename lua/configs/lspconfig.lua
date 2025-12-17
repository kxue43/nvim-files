require("nvchad.configs.lspconfig").defaults()

-- Add own LSP configs here.
vim.lsp.config("gopls", {
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = false,
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
    python = {
      analysis = {
        ignore = { "*" },
      },
    },
  },
})

-- Enable configured LSPs.
local servers = { "gopls", "lua_ls", "bashls", "basedpyright", "ruff", "ts_ls", "stylua" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
