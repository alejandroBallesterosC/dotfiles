# dotfiles

Personal macOS development environment configuration files, managed via manual symlinks.

## Documentation

- [AGENTS.md](AGENTS.md) — reference for AI coding agents (Claude Code, Codex, Cursor Agents CLI) working in this repo: architecture, key files, and per-tool config details. `CLAUDE.md` imports this file directly.
- [nvim/.config/nvim/README.md](nvim/.config/nvim/README.md) — Neovim plugin list, key bindings, and directory structure (vendored from the kickstart.nvim fork).

## What's Included

| Tool | Directory | Config Target | Description |
|------|-----------|---------------|-------------|
| **Neovim** | `nvim/` | `~/.config/nvim` | Lua-based editor config built on kickstart.nvim with 22 plugins (14 top-level + dependencies), LSP support (Python, Lua), and format-on-save |
| **Tmux** | `tmux/` | `~/.tmux.conf` | Terminal multiplexer with custom dark status bar, mouse support, focus/clipboard/passthrough settings tuned for running Claude Code across panes, and Alt-j/k window navigation |
| **Ghostty** | `ghostty/` | `~/.config/ghostty/config` | Terminal emulator font (JetBrainsMono Nerd Font) and bell settings |
| **Zsh** | `zsh/` | `~/.zshrc` | Shell functions, aliases, git-aware prompt, and Claude Code provider configuration |
| **npm** | `npm/` | `~/.npmrc` | GitHub Packages auth via `$GITHUB_NPM_TOKEN` env var, minimum release age guard |
| **uv** | `uv/` | `~/.config/uv/uv.toml` | uv global settings (required version, exclude-newer) |

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

# npm
ln -s ~/dotfiles/npm/.npmrc ~/.npmrc

# uv
mkdir -p ~/.config/uv
ln -s ~/dotfiles/uv/uv.toml ~/.config/uv/uv.toml

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
- **LSP:** Pyright + Ruff (Python), lua-language-server (Lua) — auto-installed via Mason
- **Formatting:** conform.nvim — Ruff for Python, StyLua for Lua
- **File explorer:** nvim-tree
- **Fuzzy finder:** Telescope with fzf-native
- **Completion:** blink.cmp + LuaSnip
- **Git:** gitsigns + vim-fugitive
- **Leader key:** Space

Custom plugins can be added in `nvim/.config/nvim/lua/custom/plugins/` — note the `{ import = 'custom.plugins' }` line in `init.lua` is commented out by default and must be enabled for files placed there to load. See [nvim/.config/nvim/README.md](nvim/.config/nvim/README.md) for the full plugin list and key bindings.

## Zsh Highlights

- Colored, git-aware prompt (branch name and dirty/staged status)
- `kill_port <port>` — kills processes on a given port
- `mmsync` — rsync wrapper that bypasses SSH RemoteCommand
- `dev_start` / `dev_stop` / `dev_describe` — manage the Oleum dev box EC2 instance
- Claude Code provider switching (Vertex AI / Bedrock / Anthropic)

## Tmux Highlights

- Custom dark status bar with active/inactive window tab styling
- Mouse support, 100k-line scroll history, Alt-j/k window navigation
- `focus-events`, `allow-passthrough`, `extended-keys`, and clipboard/true-color `terminal-features` tuned for running multiple concurrent Claude Code sessions across panes, locally and over SSH
