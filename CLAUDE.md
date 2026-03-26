# Dotfiles

Personal macOS development environment configuration. Manages Neovim, Zsh, Tmux, and Ghostty configs via manual symlinks from this repo to their expected locations.

## Architecture

```
dotfiles/
├── nvim/       → ~/.config/nvim (symlink)     # Neovim - kickstart.nvim based, Lua config
├── tmux/       → ~/.tmux.conf (symlink)       # Tmux multiplexer
├── ghostty/    → ~/.config/ghostty (symlink)   # Ghostty terminal
└── zsh/        → NOT symlinked                 # Zsh shell (repo is subset of ~/.zshrc)
```

Each tool directory mirrors the target filesystem layout. Configs are deployed via manual symlinks — no stow or install script.

## Key Files

| File | Purpose | Lines |
|------|---------|-------|
| `nvim/.config/nvim/init.lua` | Main Neovim config — options, keymaps, 22 plugins via lazy.nvim | 1,018 |
| `zsh/.zshrc` | Shell functions, aliases, Claude Code provider config | 63 |
| `tmux/.tmux.conf` | Status bar theme, mouse, Alt-j/k window nav | 25 |
| `ghostty/.config/ghostty/config` | Font config (JetBrainsMono Nerd Font) | 49 |

## Neovim Setup

- **Base:** kickstart.nvim (one-time copy, no upstream tracking)
- **Plugin manager:** lazy.nvim (auto-bootstraps on first launch)
- **LSP:** Mason auto-installs pyright, ruff, lua_ls, stylua
- **Formatting:** conform.nvim — Python (ruff), Lua (stylua), format on save
- **Theme:** Monokai Pro
- **Leader key:** Space
- **Extension point:** `lua/custom/plugins/init.lua` (currently empty)

## Zsh Config

The repo version (`zsh/.zshrc`) is a **subset** of the active `~/.zshrc`. The repo tracks custom content (functions, aliases, Claude Code config). The live file has additional PATH/NVM/gcloud lines added by installers.

Key content:
- `compare-worktrees()` — opens git worktrees in Cursor workspace
- `kill_port()` — kill processes on a port
- Claude Code provider switching (vertex/bedrock/anthropic)

## Important Notes

- No install script — symlinks are created manually
- No tests or CI for the dotfiles repo itself
- The `.github/workflows/stylua.yml` is inherited from kickstart.nvim and does not run on this repo
- Ghostty config is minimal (only font-family set)
- Git remote is named `dotfiles` (not `origin`)

## Common Tasks

```bash
# Check symlink state
ls -la ~/.config/nvim ~/.tmux.conf ~/.config/ghostty/config ~/.zshrc

# Update Neovim plugins
nvim --headless "+Lazy! sync" +qa

# Check Neovim health
nvim "+checkhealth"
```
