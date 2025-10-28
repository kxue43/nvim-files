# NeoVim Tips

## Perform find-and-replace

Telescope doesn't support this feature. Use the following steps instead.

- `<leader>fw` or `<leader>gu` to live grep on patterns.
- `<C-q>` to add all findings to Quickfix.
- Use command like below to work on each quickfix entry (line) or quickfix file.

  ```vim
  " Runs on each line
  :cdo s/booooom/baaaam/g | update
  " Runs on each file
  :cfdo %s/booooom/baaaaam/g | update
  ```

  `:cfdo` --- `c` for quickfix, `f` for file, `do` for "do (something)". Similarly for `:cdo`.
  `| update` means save changes only if the file was modified.

`:Telescope live_grep` accepts regex directly. `:Telescope find_files` uses fuzzy search, not regex.
