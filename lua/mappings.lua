require "nvchad.mappings"

local map = vim.keymap.set

map("n", "\\ll", function()
  local curr_file = vim.fn.expand "%:p"

  vim.fn.system("toolkit-show-md " .. curr_file .. " >/dev/null 2>&1")
end, { desc = "Convert and show the current Markdown file in browswer." })

map("n", "\\eb", function()
  print(vim.fn.expand "%:p")
end, { desc = "Echo full file path of the current buffer." })
