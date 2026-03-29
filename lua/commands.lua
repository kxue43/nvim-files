vim.api.nvim_create_user_command("KMan", function(opts)
  vim.cmd(":Man " .. opts.args .. " | only ")
end, { desc = "Open man page in new buffer.", nargs = "+" })

vim.api.nvim_create_user_command("GeminiStart", function()
  vim.cmd ":Lazy load nvim-gemini-cli "
end, { desc = "Manually load the nvim-gemini-cli plugin.", nargs = 0 })
