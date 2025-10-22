require "nvchad.mappings"

local map = vim.keymap.set

map("n", "\\eb", function()
  print(vim.fn.expand "%:p")
end, { desc = "Echo full file path of the current buffer." })
