return {
  -- Turn on format on save.
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- Change behavior of <Tab> and <S-Tab> when completion menu is visible.
  -- Change <Tab> to cmp.confirm from cmp.select_next_item.
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      local cmp = require "cmp"

      local options = require "nvchad.configs.cmp"

      local overrides = {
        mapping = {
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              if not cmp.confirm { behavior = cmp.ConfirmBehavior.Insert, select = true } then
                fallback()
              end
            elseif require("luasnip").expand_or_jumpable() then
              require("luasnip").expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              fallback()
            elseif require("luasnip").jumpable(-1) then
              require("luasnip").jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
      }

      return vim.tbl_deep_extend("force", options, overrides)
    end,
  },

  -- Pull own LSP configs.
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

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
          hidden = true, -- Include hidden files
          -- no_ignore = true,  -- Uncomment to also include gitignored files
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

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
