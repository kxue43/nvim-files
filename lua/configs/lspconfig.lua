local M = {}

M.defaults = function()
  -- First use configs from Nvchad/Nvchad.
  require("nvchad.configs.lspconfig").defaults()

  -- Always show diagnostics source.
  -- vim.diagnostics.config performs table merge on config values.
  vim.diagnostic.config {
    virtual_text = { prefix = "", source = true },
    float = { border = "single", source = true },
  }

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
    },
  })

  -- Enable configured LSPs.
  local servers = { "gopls", "lua_ls", "bashls", "basedpyright", "ruff", "ts_ls", "stylua" }
  vim.lsp.enable(servers)

  -- read :h vim.lsp.config for changing options of lsp servers
end

return M
