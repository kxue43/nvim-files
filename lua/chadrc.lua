-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "gruvbox",

  hl_override = {
    Comment = { italic = false }, -- comments in any programming languages.
    ["@comment"] = { italic = true }, -- type-annotation type of Lua comments.
  },
}

M.nvdash = { load_on_startup = false }

-- The following Mason packages will be installed by :MasonInstallAll.
M.mason = {
  pkgs = {
    "lua-language-server",
    "stylua",
    "gopls",
  },
}

return M
