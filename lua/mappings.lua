require "nvchad.mappings"

local map = vim.keymap.set
local del = vim.keymap.del

-- Delete the "toggle relative number" key map set by NvChad.
del("n", "<leader>rn")

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

map("n", "<leader>gu", function()
  local dir = vim.fn.input {
    prompt = "Grep under directory: ",
    default = "",
    completion = "dir",
  }

  require("telescope.builtin").live_grep {
    cwd = dir,
  }
end, { desc = "telescope live grep under the specified directory." })
