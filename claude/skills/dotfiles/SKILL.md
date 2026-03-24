# Dotfiles — terminal environment source of truth

The user's terminal environment is managed via a dotfiles repo checked out at `~/dotfiles`.
All config files are symlinked from this repo into their conventional locations — the repo
is the single source of truth. When suggesting edits, always target the repo path
(`~/dotfiles/...`), never the symlink target.

## Repo structure

```
~/dotfiles/
├── setup.sh                    — installs neovim, creates all symlinks, installs gopls
├── bash/dotfiles.bash          — sourced from ~/.bashrc (~/bin PATH, SSH agent forwarding fix)
├── git/gitconfig               → ~/.gitconfig
├── tmux/tmux.conf              → ~/.tmux.conf (prefix: Ctrl-a)
├── nvim/                       → ~/.config/nvim
│   ├── init.lua                — bootstraps lazy.nvim, sets leader (Space), loads lua/ modules
│   ├── cheatsheet.md           — keybinding reference, shown on bare `nvim` startup
│   ├── lua/options.lua         — vim.opt settings
│   ├── lua/keymaps.lua         — non-plugin keymaps
│   └── lua/plugins/            — lazy.nvim plugin specs
│       ├── formatting.lua      — conform.nvim (code formatting)
│       ├── git.lua             — gitsigns, fugitive, etc.
│       ├── lsp.lua             — LSP client config
│       ├── neo-tree.lua        — file explorer
│       ├── telescope.lua       — fuzzy finder
│       ├── toggleterm.lua      — embedded terminal
│       ├── treesitter.lua      — syntax highlighting / parsing
│       ├── ui.lua              — colorscheme, statusline, etc.
│       └── which-key.lua       — keybinding discovery popup
├── claude/
│   ├── agents/                 → ~/.claude/agents (shared Claude Code agents)
│   └── skills/                 → ~/.claude/skills (shared Claude Code skills)
└── .git/
```

## Symlinks created by setup.sh

| Repo path                      | Symlink target         |
|--------------------------------|------------------------|
| `~/dotfiles/nvim/`             | `~/.config/nvim`       |
| `~/dotfiles/tmux/tmux.conf`    | `~/.tmux.conf`         |
| `~/dotfiles/git/gitconfig`     | `~/.gitconfig`         |
| `~/dotfiles/claude/agents/`    | `~/.claude/agents`     |
| `~/dotfiles/claude/skills/`    | `~/.claude/skills`     |

## Key details

- **Neovim** is installed as a standalone tarball into `~/bin/` (not via system package manager).
  `~/bin` is prepended to PATH by `dotfiles.bash` so it takes priority.
- **Neovim leader key** is Space. All plugin keybindings use `<leader>`.
- **tmux prefix** is `Ctrl-a` (not the default `Ctrl-b`).
- **Git** is configured with `pull.rebase = true`, `push.default = current`, and nvim as editor.
- **SSH agent forwarding** is handled by a stable symlink trick in `dotfiles.bash` so that
  tmux reattach doesn't break the agent socket.
- **Claude Code agents and skills** are managed in this repo and symlinked into `~/.claude/`.

## How to use this skill

Before answering questions about the terminal setup, read the relevant config files from
`~/dotfiles/` so your answers reflect the user's actual configuration:

- `~/dotfiles/nvim/init.lua`
- `~/dotfiles/nvim/lua/options.lua`
- `~/dotfiles/nvim/lua/keymaps.lua`
- All files in `~/dotfiles/nvim/lua/plugins/`
- `~/dotfiles/tmux/tmux.conf`
- `~/dotfiles/nvim/cheatsheet.md`
- `~/dotfiles/bash/dotfiles.bash`
- `~/dotfiles/git/gitconfig`
- `~/dotfiles/setup.sh`

When answering:
- Reference the user's actual keybindings and config, not defaults or generic docs.
- Point to the specific file in `~/dotfiles/` where a setting lives.
- Use the user's leader key (Space) when describing neovim keybindings.
- If a feature isn't configured, say so and suggest which file to add it to.

When making changes to this repo:
- After modifying any config, update this skill file if the change affects the repo structure,
  key details, or conventions documented above.
- Keep the repo structure tree and symlink table current.
- If you add new tools, plugins, or config areas, document them here so future conversations
  have accurate context.
- If you change nvim configuration, consider updating the startup cheatsheet

$ARGUMENTS
