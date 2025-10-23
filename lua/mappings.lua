require "nvchad.mappings"

local map = vim.keymap.set

map("n", "\\eb", function()
  print(vim.fn.expand "%:p")
end, { desc = "Echo full file path of the current buffer." })

map("n", "<leader>fu", function()
  local dir = vim.fn.input {
    prompt = "Find under directory: ",
    default = "",
    completion = "dir",
  }

  dir = vim.fn.fnamemodify(dir, ":p")

  if vim.fn.isdirectory(dir) ~= 1 then
    vim.notify("Error: " .. dir .. " is not a directory.", vim.log.levels.ERROR)

    return
  end

  require("telescope.builtin").find_files {
    cwd = dir,
  }
end, { desc = "telescope find files under the specified directory." })
