# dotfiles

Personal macOS development environment configuration files, managed via manual symlinks.

## What's Included

| Tool | Directory | Config Target | Description |
|------|-----------|---------------|-------------|
| **Neovim** | `nvim/` | `~/.config/nvim` | Lua-based editor config built on kickstart.nvim with 22 plugins, LSP support (Python, Lua), and format-on-save |
| **Tmux** | `tmux/` | `~/.tmux.conf` | Terminal multiplexer with custom dark status bar, mouse support, and Alt-j/k window navigation |
| **Ghostty** | `ghostty/` | `~/.config/ghostty/config` | Terminal emulator font configuration (JetBrainsMono Nerd Font) |
| **Zsh** | `zsh/` | `~/.zshrc` | Shell functions, aliases, and Claude Code provider configuration |

## Setup

Clone and create symlinks:

```bash
git clone https://github.com/alejandroBallesterosC/dotfiles.git ~/dotfiles

# Neovim
ln -s ~/dotfiles/nvim/.config/nvim ~/.config/nvim

# Tmux
ln -s ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf

# Ghostty
ln -s ~/dotfiles/ghostty/.config/ghostty/config ~/.config/ghostty/config

# Zsh (copy rather than symlink — merge with your existing .zshrc)
cat ~/dotfiles/zsh/.zshrc >> ~/.zshrc
```

Neovim plugins and LSP servers install automatically on first launch via lazy.nvim and Mason.

## Dependencies

- [Neovim](https://neovim.io/) 0.9+
- [JetBrainsMono Nerd Font](https://www.nerdfonts.com/)
- [ripgrep](https://github.com/BurntSushi/ripgrep) (for Telescope live grep)
- [Ghostty](https://ghostty.org/)
- [tmux](https://github.com/tmux/tmux)

## Neovim Highlights

- **Theme:** Monokai Pro
- **Plugin manager:** lazy.nvim (auto-bootstraps)
- **LSP:** Pyright + Ruff (Python), lua_ls (Lua) — auto-installed via Mason
- **Formatting:** conform.nvim — Ruff for Python, StyLua for Lua
- **File explorer:** nvim-tree
- **Fuzzy finder:** Telescope with fzf-native
- **Completion:** blink.cmp + LuaSnip
- **Git:** gitsigns + vim-fugitive
- **Leader key:** Space

Custom plugins can be added in `nvim/.config/nvim/lua/custom/plugins/`.

## Zsh Highlights

- `compare-worktrees` — opens all git worktrees in a Cursor workspace
- `kill_port <port>` — kills processes on a given port
- Claude Code provider switching (Vertex AI / Bedrock / Anthropic)
