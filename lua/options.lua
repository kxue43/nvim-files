require "nvchad.options"

-- add yours here!
vim.filetype.add {
  extension = {
    bashrc = "sh",
  },
}

local o = vim.o

-- Enable folding via treesitter.
o.foldmethod = "expr"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- o.cursorlineopt ='both' -- to enable cursorline!
