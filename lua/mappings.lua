require "nvchad.mappings"

local map = vim.keymap.set
local del = vim.keymap.del

-- Delete the "toggle relative number" key map set by NvChad.
del("n", "<leader>rn")

-- Delete the "toggle floating term", "toggle vertical term" and "toggle horizontal term" key maps set by NvChad.
del({ "n", "t" }, "<A-i>")
del({ "n", "t" }, "<A-v>")
del({ "n", "t" }, "<A-h>")

-- Delete the <C-x> key map that escape terminal mode. Use <C-\\><C-n> instead.
-- <C-x> is reserved for Readline.
del("t", "<C-x>")

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

-- Stretch the current NvChad htoggleTerm to fullscreen.
map("t", "<A-k>", function()
  -- Get alternate buffer number.
  local alt_buf = vim.fn.bufnr "#"

  if alt_buf == -1 or not vim.api.nvim_buf_is_valid(alt_buf) then
    -- If alternate buffer doesn't exist or is invalid, just return.
    return
  end

  if vim.fn.bufwinnr(alt_buf) <= 0 then
    -- If alternate buffer is not visible, terminal window is already fullscreen. Just return.
    return
  end

  -- Exit from terminal mode to normal mode.
  vim.cmd.stopinsert()

  -- Move to the window above the terminal.
  vim.cmd "wincmd k"

  -- Hide the window.
  vim.cmd "hide"

  -- Return to insert mode in the terminal window
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("a", true, false, true), "n", false)
end, { desc = "Stretch the current htoggleTerm to fullscreen." })

-- Put the current NvChad htoggleTerm at the bottom of the window.
map("t", "<A-j>", function()
  -- Get alternate buffer number.
  local alt_buf = vim.fn.bufnr "#"

  if alt_buf == -1 or not vim.api.nvim_buf_is_valid(alt_buf) then
    -- If alternate buffer doesn't exist or is invalid, just return.
    return
  end

  if vim.fn.bufwinnr(alt_buf) > 0 then
    -- If alternate buffer is visible, terminal window is already at the bottom. Just return.
    return
  end

  -- switch to alternate buffer.
  vim.api.nvim_set_current_buf(alt_buf)

  -- Open up terminal at the bottom again.
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "Put the current htoggleTerm at the bottom of the window." })

map({ "n" }, "<A-h>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "Open a new htoggleTerm at the bottom of the window." })

map("t", "<A-h>", function()
  -- Get alternate buffer number
  local alt_buf = vim.fn.bufnr "#"

  if alt_buf == -1 or not vim.api.nvim_buf_is_valid(alt_buf) then
    -- If alternate buffer doesn't exist or is invalid, just return.
    return
  end

  if vim.fn.bufwinnr(alt_buf) > 0 then
    -- If alternate buffer is visible, terminal is already at bottom.
    -- Just use "nvchad.term.toggle" to hide it.
    require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
  else
    -- If alternate buffer is not visible, set it as the current buffer,
    -- and terminal is automatically hidden.
    vim.api.nvim_set_current_buf(alt_buf)
  end
end, { desc = "Hide the current htoggleTerm, fullscreen or not." })
