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
| **Claude Code** | `claude-code/` | `~/.claude/{settings.json,statusline.sh,CLAUDE.md,docs,agents,skills}` | Settings, custom statusline, global instructions, and reference docs applied to every session |

## Setup

Clone and run the install script:

```bash
git clone https://github.com/alejandroBallesterosC/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` creates all the config symlinks (Neovim, tmux, Ghostty, npm, uv, zsh, and the Claude Code entries under `~/.claude`) and installs `ruff` via `uv tool install ruff`. It is idempotent: symlinks that already point at the repo are left alone, and any pre-existing real file or differing symlink at a target path is moved to `<target>.backup.<epoch>` before the new link is created. Run it again any time after pulling changes.

The script symlinks `~/.zshrc` to `zsh/.zshrc` (backing up an existing file). If you would rather keep your own `~/.zshrc` and merge, skip the script for zsh and append instead: `cat ~/dotfiles/zsh/.zshrc >> ~/.zshrc`.

Neovim plugins and LSP servers install automatically on first launch via lazy.nvim and Mason. `ruff` is not installed through Mason (see [Neovim Highlights](#neovim-highlights)); `install.sh` installs it via uv, and Neovim also installs it on demand via uv if it is missing.

## Dependencies

- [Neovim](https://neovim.io/) 0.9+
- [JetBrainsMono Nerd Font](https://www.nerdfonts.com/)
- [ripgrep](https://github.com/BurntSushi/ripgrep) (for Telescope live grep)
- [Ghostty](https://ghostty.org/)
- [tmux](https://github.com/tmux/tmux)
- [uv](https://docs.astral.sh/uv/) (installs `ruff` for Neovim; `install.sh` and the editor both call `uv tool install ruff`)

## Neovim Highlights

- **Theme:** Monokai Pro
- **Plugin manager:** lazy.nvim (auto-bootstraps)
- **LSP:** Pyright + Ruff (Python), lua-language-server (Lua) — Pyright and lua-language-server auto-installed via Mason; the Ruff CLI is installed via `uv tool install ruff` (Mason installs Ruff from PyPI into a python3 venv, which needs the `python3-venv`/`ensurepip` system package — the self-contained Ruff binary from uv avoids that) and resolved from `PATH`
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

## Claude Code Highlights

- Statusline shows cwd, git branch, model, output style, and context window usage
- Corrects context usage for models where Claude Code under-reports the context window size (see [anthropics/claude-code#63447](https://github.com/anthropics/claude-code/issues/63447))
- `settings.json` holds enabled plugins, permissions, effort level, and notification channel — account-specific state (auth, session/usage data) lives elsewhere under `~/.claude/` and isn't tracked here
- `CLAUDE.md` and `docs/` hold global instructions (writing style, TDD process, uv/Python conventions) applied to every session
- `agents/` and `skills/` are tracked as empty placeholders (`.gitkeep`) — custom agents/skills live in a separate private repo
