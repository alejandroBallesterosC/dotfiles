# Dotfiles

Personal macOS development environment configuration. Manages Neovim, Zsh, Tmux, Ghostty, uv, and npm configs via manual symlinks from this repo to their expected locations.

This file is the canonical reference for AI coding agents working in this repo (Claude Code reads it via the `@AGENTS.md` import in `CLAUDE.md`; Codex, Cursor Agents CLI, and similar tools read `AGENTS.md` directly).

## Architecture

```
dotfiles/
├── claude-code/ → ~/.claude/statusline.sh, ~/.claude/settings.json (symlinks)  # Claude Code statusline + settings
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
| `zsh/.zshrc` | Shell functions, aliases, prompt, Claude Code provider config | 113 |
| `tmux/.tmux.conf` | Status bar theme, mouse, focus/clipboard/passthrough settings, Alt-j/k window nav | 39 |
| `ghostty/.config/ghostty/config` | Font config (JetBrainsMono Nerd Font) and bell settings | 50 |
| `npm/.npmrc` | GitHub Packages auth via env var, minimum release age guard | 2 |
| `uv/uv.toml` | uv global settings (required-version, exclude-newer) | 2 |
| `claude-code/.claude/statusline.sh` | Claude Code statusline: cwd, git branch, model, output style, context usage — corrects `context_window_size` for models Claude Code under-reports (see below) | 45 |
| `claude-code/.claude/settings.json` | Claude Code settings: statusline wiring, enabled plugins, permissions, effort level, notification channel | 32 |

## Neovim Setup

- **Base:** kickstart.nvim (one-time copy, no upstream tracking)
- **Plugin manager:** lazy.nvim (auto-bootstraps on first launch) — 14 top-level plugins plus dependencies (22 total, pinned in `lazy-lock.json`)
- **LSP:** Mason auto-installs `pyright` and `ruff` (Python) and `lua-language-server` (Lua), enabled via `vim.lsp.enable`
- **Formatting:** conform.nvim — Python (`ruff_organize_imports`, `ruff_format`), Lua (`stylua`, installed via Mason as a formatter, not an LSP server), format on save for all filetypes except C/C++
- **Theme:** Monokai Pro
- **Leader key:** Space
- **Extension point:** `lua/custom/plugins/init.lua` (currently returns `{}`). The `{ import = 'custom.plugins' }` line in `init.lua` is commented out — uncomment it before adding files here, or they won't load.

## Tmux Config

`tmux/.tmux.conf` is tuned for running multiple concurrent Claude Code sessions across panes, both locally (Ghostty → tmux) and over SSH into remote dev boxes (Ghostty → SSH → tmux):

- `focus-events on` — forwards terminal focus in/out events into panes (Claude Code uses these for cursor visibility in inactive panes; tmux does not forward them by default regardless of terminal)
- `allow-passthrough on`, `extended-keys on`, `terminal-features 'xterm*:extkeys'` — required for Claude Code's notification/progress-bar passthrough and for distinguishing Shift+Enter from Enter (per Claude Code's official terminal-config docs)
- `terminal-features ",xterm-ghostty:RGB,xterm-256color:RGB"` — true color for both direct local Ghostty sessions (`TERM=xterm-ghostty`) and remote SSH sessions (`TERM=xterm-256color`, set via `SetEnv` in `~/.ssh/config` since remote hosts typically lack the `xterm-ghostty` terminfo entry)
- `set-clipboard on` — OSC 52 clipboard passthrough, works over SSH
- `monitor-activity on`, `visual-activity on`, `monitor-bell on` — surface which background pane/window needs attention
- `escape-time 10` — matches tmux's modern default (tmux ≥3.5); kept explicit as a fallback for older tmux on remote boxes

## Zsh Config

The repo `zsh/.zshrc` is symlinked to `~/.zshrc`. Secrets are stored in `~/.zshrc.secrets` (not tracked) and sourced at shell startup.

Key content:
- Colored, git-aware prompt (`vcs_info`-based; shows branch and dirty/staged status)
- `kill_port()` — kill processes on a port
- `mmsync()` — rsync wrapper that bypasses SSH RemoteCommand
- `dev_start()` / `dev_stop()` / `dev_describe()` — start, stop, and check status of the Oleum dev box EC2 instance (stopping avoids compute billing; EBS storage still bills)
- Aliases: `sublime` (→ `subl`), `clauded` (→ `claude --dangerously-skip-permissions`)
- Claude Code provider switching via `CLAUDE_PROVIDER` (vertex/bedrock/anthropic); currently set to `bedrock`
- PATH setup for nvm, homebrew sqlite/openjdk, pixi, gcloud, `~/.local/bin`

## Claude Code Config

`claude-code/.claude/settings.json` and `claude-code/.claude/statusline.sh` are symlinked to `~/.claude/settings.json` and `~/.claude/statusline.sh` respectively. `settings.json`'s `statusLine.command` points at the symlinked script path, so both need to exist for the statusline to render.

`settings.json` covers statusline wiring, enabled plugins, permissions, effort level, and notification channel — anything account-specific (auth, usage/session state) lives elsewhere under `~/.claude/` and is not tracked here.

The statusline shows: current dir (`~` shortened), git branch, model display name, output style (if non-default), and context window usage (`ctx: N% (Nk left)`).

Context usage is computed manually from `context_window.total_input_tokens` rather than trusting Claude Code's own `used_percentage`/`context_window_size` fields, because Claude Code (as of 2.1.200) under-reports `context_window_size` as 200000 for several models that actually run with a 1M window (Opus 4.6/4.7/4.8, Sonnet 4.6/5, Fable 5, Mythos 5) — see [anthropics/claude-code#63447](https://github.com/anthropics/claude-code/issues/63447). The script overrides the denominator to 1,000,000 for those models by matching `model.id`, but only when Claude Code's reported value is smaller, so the override becomes a no-op once upstream fixes the report.

## Important Notes

- No install script — symlinks are created manually
- Secrets live in `~/.zshrc.secrets` (not tracked) — referenced via env vars (e.g., `$GITHUB_NPM_TOKEN` in `.npmrc`)
- No tests or CI for the dotfiles repo itself
- The `.github/workflows/stylua.yml` is inherited from kickstart.nvim and does not run on this repo
- Ghostty config is minimal (font family and bell settings only)
- Git remote is named `dotfiles` (not `origin`)

## Common Tasks

```bash
# Check symlink state
ls -la ~/.config/nvim ~/.tmux.conf ~/.config/ghostty/config ~/.zshrc ~/.npmrc ~/.config/uv/uv.toml

# Update Neovim plugins
nvim --headless "+Lazy! sync" +qa

# Check Neovim health
nvim "+checkhealth"

# Reload tmux config in an attached session
tmux source-file ~/.tmux.conf
```
