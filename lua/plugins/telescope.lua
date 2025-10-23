return {
  -- Make :Telescope live_grep also search hidden (dot) files.
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    opts = function()
      local opts = require "nvchad.configs.telescope"

      opts.defaults.vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden", -- Search hidden files
        "--glob",
        "!**/.git/*", -- But exclude .git directory
      }

      opts.pickers = {
        find_files = {
          hidden = false, -- Include hidden files
          no_ignore = true, -- Uncomment to also include gitignored files
        },
        live_grep = {
          additional_args = function()
            return { "--hidden" }
          end,
        },
      }

      return opts
    end,
  },
}
