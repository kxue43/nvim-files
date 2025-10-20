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

  -- Gitsigns key maps.
  {
    "lewis6991/gitsigns.nvim",
    event = "User FilePost",
    opts = function()
      local options = require "nvchad.configs.gitsigns"

      options.on_attach = function(bufnr)
        local gitsigns = require "gitsigns"

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal { "]c", bang = true }
          else
            gitsigns.nav_hunk "next"
          end
        end, { desc = "Next diff or next hunk." })

        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal { "[c", bang = true }
          else
            gitsigns.nav_hunk "prev"
          end
        end, { desc = "Previous diff or previous hunk." })

        -- Actions
        map("n", "\\hs", gitsigns.stage_hunk, { desc = "Stage/unstage hunk." })
        map("n", "\\hr", gitsigns.reset_hunk, { desc = "Reset hunk." })
        map("n", "\\hp", gitsigns.preview_hunk, { desc = "Preview hunk." })
        map("n", "\\hi", gitsigns.preview_hunk_inline, { desc = "Preview hunk inline." })

        map("v", "\\hs", function()
          gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
        end, { desc = "Stage/unstage visually selected hunk." })

        map("v", "\\hr", function()
          gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
        end, { desc = "Reset visually selected hunk." })

        map("n", "\\hS", gitsigns.stage_buffer, { desc = "Stage buffer." })
        map("n", "\\hR", gitsigns.reset_buffer, { desc = "Reset buffer." })

        map("n", "\\hb", function()
          gitsigns.blame_line { full = true }
        end, { desc = "Blame current line." })

        map("n", "\\hd", gitsigns.diffthis, { desc = "Buffer git diff" })

        map("n", "\\hD", function()
          gitsigns.diffthis "~"
        end, { desc = "Buffer git diff --cached" })

        map("n", "\\hq", gitsigns.setqflist, { desc = "Show hunks of current buffer." })
        map("n", "\\hQ", function()
          gitsigns.setqflist "all"
        end, { desc = "Show hunks of whole repository." })

        -- Toggles
        map("n", "\\tb", gitsigns.toggle_current_line_blame, { desc = "Toggle line blame." })
        map("n", "\\tw", gitsigns.toggle_word_diff, { desc = "Toggle word diff." })
      end

      return options
    end,
  },
}
