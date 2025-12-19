require "nvchad.mappings"

local map = vim.keymap.set
local del = vim.keymap.del

-- Delete the "toggle relative number" key map set by NvChad.
del("n", "<leader>rn")

-- Delete the "toggle floating term" key map set by NvChad.
del({ "n", "t" }, "<A-i>")

-- Show full path of the current buffer.
map("n", "\\eb", function()
  print(vim.fn.expand "%:p")
end, { desc = "Echo full file path of the current buffer." })

-- Telescope find file under certain directory.
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

-- Telescope grep under certain directory.
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

-- Toggle full-window terminal.
map({ "n", "t" }, "<A-f>", function()
  require("nvchad.term").toggle { pos = "sp", id = "kxue43_ftoggleTerm", size = 1 }
end, { desc = "terminal toggleable full-window term" })

-- Stretch current NvChad htoggleTerm to window top.
map("t", "<A-k>", "<C-\\><C-n><C-w>k:hide<CR>a", { desc = "Stretch current htoggleTerm to window top." })

-- Return stretched NvCahd htoggleTerm to original position.
map("t", "<A-j>", function()
  -- Get alternate buffer number
  local alt_buf = vim.fn.bufnr "#"

  -- Switch to alternate buffer if it exists
  if alt_buf ~= -1 and vim.api.nvim_buf_is_valid(alt_buf) then
    vim.api.nvim_set_current_buf(alt_buf)
  end

  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "Return Stretched htoggleTerm to original position." })
