return {
  "ndsl6211/nvim-gemini-cli",
  build = "cd server && go build -o ../bin/gemini-mcp-server",
  config = function()
    require("gemini-cli").setup {
      -- Auto-setup default keymaps (<leader>gc, <leader>gs, <leader>gf, <leader>ga)
      setup_keymaps = true,

      -- Set to true to accept diffs with :w in the diff window
      allow_w_to_accept = true,
    }
  end,
}
