# Dotfiles

Johnny's dotfiles: nvim, bash, tmux, git, and Claude Code configs.
Symlinked into place by `setup.sh` (e.g. `~/.config/nvim -> ~/dotfiles/nvim`).

## Testing Neovim Config

Most nvim plugins are lazy-loaded (`event = "BufReadPost"`, `keys = ...`, etc).
A bare `nvim --headless -c 'qall'` will NOT load them and will miss errors.

To properly test, open a real file and let the event loop settle:

```bash
# Write a test harness that waits, captures :messages, then exits
cat > /tmp/nvim_test.lua << 'EOF'
vim.defer_fn(function()
  local msgs = vim.api.nvim_exec2("messages", {output=true}).output
  if msgs ~= "" then
    io.stderr:write(msgs .. "\n")
  end
  io.stderr:write("=== DONE ===\n")
  vim.cmd("qall!")
end, 3000)
EOF

# Open a file to trigger BufReadPost (loads lsp, treesitter, etc)
nvim --headless -S /tmp/nvim_test.lua some_file.lua 2>&1

# Grep for errors — clean startup should only show parser install
# messages (if first run) and "=== DONE ==="
```

Key points:
- Always open a file argument to trigger `BufReadPost`-gated plugins
- Use `vim.defer_fn` with enough delay (3s) for async plugin init
- Write the test script to a file — inline `-c 'lua ...'` breaks on `!` escaping in bash
- Check stderr: nvim writes lua errors and plugin failures there
