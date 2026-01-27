return {
  -- Always load which-key.
  {
    "folke/which-key.nvim",
    lazy = false,
  },

  -- Pull own LSP configs.
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Ensure tree-sitter parsers.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "go",
        "bash",
        "python",
        "javascript",
        "typescript",
        "java",
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "awk",
        "markdown",
        "markdown_inline",
      },
    },
    lazy = false,
    branch = "main",
  },
}
