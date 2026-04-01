# Dotfiles

Personal macOS development environment configuration. Manages Neovim, Zsh, Tmux, Ghostty, uv, and npm configs via manual symlinks from this repo to their expected locations.

## Architecture

```
dotfiles/
├── ghostty/    → ~/.config/ghostty (symlink)   # Ghostty terminal
├── npm/        → ~/.npmrc (symlink)            # npm config (auth token via $GITHUB_NPM_TOKEN env var)
├── nvim/       → ~/.config/nvim (symlink)      # Neovim - kickstart.nvim based, Lua config
├── tmux/       → ~/.tmux.conf (symlink)        # Tmux multiplexer
├── uv/         → ~/.config/uv/uv.toml (symlink) # uv Python package manager
└── zsh/        → ~/.zshrc (symlink)            # Zsh shell config
```

Each tool directory mirrors the target filesystem layout. Configs are deployed via manual symlinks — no stow or install script.

## Key Files

| File | Purpose | Lines |
|------|---------|-------|
| `nvim/.config/nvim/init.lua` | Main Neovim config — options, keymaps, 22 plugins via lazy.nvim | 1,018 |
| `zsh/.zshrc` | Shell functions, aliases, Claude Code provider config | 65 |
| `tmux/.tmux.conf` | Status bar theme, mouse, Alt-j/k window nav | 25 |
| `ghostty/.config/ghostty/config` | Font config (JetBrainsMono Nerd Font) | 49 |
| `npm/.npmrc` | npm registry config, GitHub Packages auth via env var | 2 |
| `uv/uv.toml` | uv global settings (required-version, exclude-newer) | 2 |

## Neovim Setup

- **Base:** kickstart.nvim (one-time copy, no upstream tracking)
- **Plugin manager:** lazy.nvim (auto-bootstraps on first launch)
- **LSP:** Mason auto-installs pyright, ruff, lua_ls, stylua
- **Formatting:** conform.nvim — Python (ruff), Lua (stylua), format on save
- **Theme:** Monokai Pro
- **Leader key:** Space
- **Extension point:** `lua/custom/plugins/init.lua` (currently empty)

## Zsh Config

The repo `zsh/.zshrc` is symlinked to `~/.zshrc`. Secrets are stored in `~/.zshrc.secrets` (not tracked) and sourced at shell startup.

Key content:
- `kill_port()` — kill processes on a port
- Claude Code provider switching (vertex/bedrock/anthropic)
- PATH setup for nvm, yarn, homebrew, pixi, gcloud

## Important Notes

- No install script — symlinks are created manually
- Secrets live in `~/.zshrc.secrets` (not tracked) — referenced via env vars (e.g., `$GITHUB_NPM_TOKEN` in `.npmrc`)
- No tests or CI for the dotfiles repo itself
- The `.github/workflows/stylua.yml` is inherited from kickstart.nvim and does not run on this repo
- Ghostty config is minimal (only font-family set)
- Git remote is named `dotfiles` (not `origin`)

## Common Tasks

```bash
# Check symlink state
ls -la ~/.config/nvim ~/.tmux.conf ~/.config/ghostty/config ~/.zshrc ~/.npmrc ~/.config/uv/uv.toml

# Update Neovim plugins
nvim --headless "+Lazy! sync" +qa

# Check Neovim health
nvim "+checkhealth"
```
