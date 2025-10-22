return {
  -- Turn on format on save.
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- Python linters via nvim-lint. Only loaded on 'python' file type!
  {
    "mfussenegger/nvim-lint",
    ft = { "python" },
    opts = {
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        python = { "flake8", "mypy" },
        -- Use the "*" filetype to run linters on all filetypes.
        -- ['*'] = { 'global linter' },
        -- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
        -- ['_'] = { 'fallback linter' },
        -- ["*"] = { "typos" },
      },
      -- LazyVim extension to easily override linter options
      -- or add custom linters.
      ---@type table<string,table>
      linters = {
        -- -- Example of using selene only when a selene.toml file is present
        -- selene = {
        --   -- `condition` is another LazyVim extension that allows you to
        --   -- dynamically enable/disable linters based on the context.
        --   condition = function(ctx)
        --     return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
        --   end,
        -- },
      },
    },
    config = function(_, opts)
      local M = {}

      local lint = require "lint"
      for name, linter in pairs(opts.linters) do
        if type(linter) == "table" and type(lint.linters[name]) == "table" then
          lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
          if type(linter.prepend_args) == "table" then
            lint.linters[name].args = lint.linters[name].args or {}
            vim.list_extend(lint.linters[name].args, linter.prepend_args)
          end
        else
          lint.linters[name] = linter
        end
      end
      lint.linters_by_ft = opts.linters_by_ft

      function M.debounce(ms, fn)
        local timer = vim.uv.new_timer()
        return function(...)
          local argv = { ... }
          timer:start(ms, 0, function()
            timer:stop()
            vim.schedule_wrap(fn)(unpack(argv))
          end)
        end
      end

      function M.lint()
        -- Use nvim-lint's logic first:
        -- * checks if linters exist for the full filetype first
        -- * otherwise will split filetype by "." and add all those linters
        -- * this differs from conform.nvim which only uses the first filetype that has a formatter
        local names = lint._resolve_linter_by_ft(vim.bo.filetype)

        -- Create a copy of the names table to avoid modifying the original.
        names = vim.list_extend({}, names)

        -- Add fallback linters.
        if #names == 0 then
          vim.list_extend(names, lint.linters_by_ft["_"] or {})
        end

        -- Add global linters.
        vim.list_extend(names, lint.linters_by_ft["*"] or {})

        -- Filter out linters that don't exist or don't match the condition.
        local ctx = { filename = vim.api.nvim_buf_get_name(0) }
        ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
        names = vim.tbl_filter(function(name)
          local linter = lint.linters[name]
          if not linter then
            LazyVim.warn("Linter not found: " .. name, { title = "nvim-lint" })
          end
          return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
        end, names)

        -- Run linters.
        if #names > 0 then
          lint.try_lint(names)
        end
      end

      vim.api.nvim_create_autocmd(opts.events, {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = M.debounce(100, M.lint),
      })
    end,
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

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "go",
        "python",
        "javascript",
        "typescript",
        "java",
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
      },
    },
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
  },
}
