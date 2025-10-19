vim.api.nvim_create_user_command("KMan", function(opts)
  vim.cmd(":Man " .. opts.args .. " | only | NvimTreeToggle")
end, { desc = "Open man page in new buffer as the only window.", nargs = "+" })
