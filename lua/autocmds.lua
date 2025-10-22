require "nvchad.autocmds"

local map = vim.keymap.set

-- All shell scripts are in Bash.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "bash", "sh" },
  callback = function()
    vim.g.is_bash = 1
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    map("n", "\\ll", function()
      local curr_file = vim.fn.expand "%:p"

      vim.fn.system("toolkit-show-md " .. curr_file .. " >/dev/null 2>&1")
    end, { buffer = true, desc = "Convert and show the current Markdown file in browswer." })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  callback = function()
    map("n", "grl", function()
      vim.cmd "LspTypescriptSourceAction"
    end, { buffer = true, desc = "List TypeScript source actions." })
  end,
})
