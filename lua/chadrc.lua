-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {
  base46 = {
    theme = "gruvbox",

    hl_override = {
      -- Making comments lighter. For details, see :help nvui.base46
      Comment = { fg = "#928374" }, -- Targeting integrations/defaults.lua
      ["@comment"] = { fg = "#928374" }, -- Targeting integrations/treesitter.lua
      Folded = { fg = "#bdae93" }, -- Make Folded more visible; integrations/defaults.lua
    },
  },

  ui = {
    tabufline = { lazyload = false },
  },

  nvdash = { load_on_startup = false },

  mason = {
    pkgs = {
      "lua-language-server",
      "stylua",
      "gopls",
      "bash-language-server",
      "prettier",
      "basedpyright",
      "ruff",
      "typescript-language-server",
    },
    -- Mypy, flake8 and black should be provided from the project's virtualenv rather than by Mason.
    -- Currently ruff is used for linting and formatting, but flake8 and black still remain in the skip list.
    -- Astral.sh has a beta type-checker ty, which may replace mypy in the future.
    skip = {
      "mypy",
      "flake8",
      "black",
      "eslint-lsp",
    },
  },
}

return M
