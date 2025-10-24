-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {
  base46 = {
    theme = "gruvbox_light",

    hl_override = {
      Comment = { italic = false }, -- comments in any programming languages.
      ["@comment"] = { italic = true }, -- type-annotation type of Lua comments.
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
      "typescript-language-server",
    },
    -- Mypy, flake8 and black should be provided from the project's virtualenv
    -- rather than by Mason.
    skip = {
      "mypy",
      "flake8",
      "black",
      "eslint-lsp",
    },
  },
}

return M
