# Neovim Cheat Sheet
> Leader key is **Space**. Press Space and wait to see all bindings (which-key).

## Navigation
| Key | Action |
|-----|--------|
| `Ctrl-h/j/k/l` | Move between splits |
| `Shift-h` / `Shift-l` | Previous / next buffer |
| `gd` | Go to definition (LSP) |
| `gr` | Find references (LSP) |
| `K` | Hover docs (LSP) |

## File & Search
| Key | Action |
|-----|--------|
| `Space f f` | Find files (telescope) |
| `Space f g` | Live grep across project |
| `Space f b` | Switch buffer |
| `Space f h` | Search help tags |
| `Space e` | Toggle file tree (neo-tree) |

## Editing
| Key | Action |
|-----|--------|
| `Space r n` | Rename symbol (LSP) |
| `Space c a` | Code actions (LSP) |
| `Space d` | Show line diagnostics (LSP) |
| `Space i h` | Toggle inlay hints |
| `J` / `K` (visual) | Move selected lines down / up |
| `Esc` | Clear search highlight |
| `Tab` / `Shift-Tab` | Cycle completion menu |
| `Ctrl-Space` | Trigger completion |

## Git (in files)
| Key | Action |
|-----|--------|
| `]c` / `[c` | Next / previous hunk |
| `Space h s` | Stage hunk (gitsigns) |
| `Space h u` | Undo stage hunk |
| `Space h p` | Preview hunk inline |
| `Space h b` | Blame current line |

## Git (diffview)
| Key | Action |
|-----|--------|
| `Space g d` | Open diff view |
| `Space g c` | Close diff view |
| `]c` / `[c` | Next / previous hunk |
| `s` / `-` | Stage / unstage file (in file panel) |
| `S` / `U` | Stage / unstage all files |
| `do` | Pull hunk from other side (diffget) |
| `dp` | Push hunk to other side (diffput) |
| `:w` on left pane | Write index buffer to stage edits |
| `g?` | Show all diffview keymaps |

> **Hunk-level staging in diffview**: Under "Changes", the left pane
> is the index. Focus the left pane, use `do` to pull a hunk from the
> working tree, then `:w` to stage it. Under "Staged changes", the
> index is on the right — edit and `:w` to unstage.

## Terminal
| Key | Action |
|-----|--------|
| `Ctrl-\` | Toggle floating terminal |
| `Space t t` | Toggle floating terminal |
| `Space t h` | Toggle horizontal terminal (pane below) |
| `Space t v` | Toggle vertical terminal (pane right) |
| `Ctrl-\ Ctrl-n` | Terminal → normal mode (yank, scroll, etc) |
| `i` | Back to terminal input |

> **Claude in the terminal**: `Ctrl-\` to open a terminal, then run `claude`.
> You're now in Claude Code inside neovim. `Ctrl-\` again to hide it,
> and again to bring it back — your session stays alive.
>
> **Navigating panes**: `Ctrl-\ Ctrl-n` to enter normal mode, then
> `Ctrl-h/j/k/l` to move to another split. `i` to resume typing when
> you return to the terminal pane.

## Tmux (prefix is Ctrl-a)
| Key | Action |
|-----|--------|
| `Ctrl-a |` | Split vertically |
| `Ctrl-a -` | Split horizontally |
| `Ctrl-a h/j/k/l` | Move between panes |
| `Ctrl-a c` | New window |
| `Ctrl-a 1-9` | Switch to window N |
| `Ctrl-a d` | Detach session |
| `Ctrl-a r` | Reload tmux config |

## Useful Commands
| Command | Action |
|---------|--------|
| `:Lazy` | Plugin manager (update, clean, profile) |
| `:Mason` | LSP server manager (install, update) |
| `:checkhealth` | Diagnose setup issues |
| `:TSUpdate` | Update treesitter parsers |
