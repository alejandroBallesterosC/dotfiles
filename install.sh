#!/usr/bin/env bash
# ABOUTME: Idempotent setup script for this dotfiles repo — creates the config
# ABOUTME: symlinks and installs the uv-managed tools (ruff) needed for Neovim.
set -euo pipefail

# Resolve the repo root from this script's location so it works regardless of the
# current working directory or where the repo was cloned.
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info() { printf '\033[0;34m[install]\033[0m %s\n' "$1"; }
warn() { printf '\033[0;33m[install]\033[0m %s\n' "$1" >&2; }

# link SRC DST — symlink DST -> SRC.
#  - Creates DST's parent directory.
#  - Skips if DST already points at SRC (idempotent).
#  - Backs up an existing real file/dir/other symlink at DST to DST.backup.<epoch>.
link() {
  local src="$1" dst="$2"
  if [ ! -e "$src" ]; then
    warn "source missing, skipping: $src"
    return
  fi
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    info "ok: $dst -> $src"
    return
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    local backup="$dst.backup.$(date +%s)"
    warn "backing up existing $dst -> $backup"
    mv "$dst" "$backup"
  fi
  ln -s "$src" "$dst"
  info "linked: $dst -> $src"
}

info "Using dotfiles at: $DOTFILES_DIR"

# --- Symlinks -----------------------------------------------------------------
# Neovim
link "$DOTFILES_DIR/nvim/.config/nvim" "$HOME/.config/nvim"

# Tmux
link "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

# Ghostty (symlink the config file; Ghostty may write other state into the dir)
link "$DOTFILES_DIR/ghostty/.config/ghostty/config" "$HOME/.config/ghostty/config"

# npm
link "$DOTFILES_DIR/npm/.npmrc" "$HOME/.npmrc"

# uv
link "$DOTFILES_DIR/uv/uv.toml" "$HOME/.config/uv/uv.toml"

# Zsh
link "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

# Claude Code (individual entries under ~/.claude)
link "$DOTFILES_DIR/claude-code/.claude/settings.json" "$HOME/.claude/settings.json"
link "$DOTFILES_DIR/claude-code/.claude/statusline.sh" "$HOME/.claude/statusline.sh"
link "$DOTFILES_DIR/claude-code/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
link "$DOTFILES_DIR/claude-code/docs" "$HOME/.claude/docs"
link "$DOTFILES_DIR/claude-code/agents" "$HOME/.claude/agents"
link "$DOTFILES_DIR/claude-code/skills" "$HOME/.claude/skills"

# --- Tools --------------------------------------------------------------------
# Ruff is the Python linter/formatter used by Neovim (Ruff LSP + conform formatters).
# It is installed as a self-contained binary via uv rather than through Mason, whose
# PyPI installer needs the python3-venv/ensurepip system package. uv places the `ruff`
# shim in ~/.local/bin, which zsh/.zshrc adds to PATH. Neovim also installs ruff on
# demand (see the ensure-ruff autocmd in nvim/.config/nvim/init.lua); doing it here
# means the shell and editor find it immediately on a fresh machine.
if command -v uv >/dev/null 2>&1; then
  if command -v ruff >/dev/null 2>&1; then
    info "ruff already on PATH: $(command -v ruff)"
  else
    info "Installing ruff via 'uv tool install ruff'…"
    uv tool install ruff
  fi
else
  warn "uv not found on PATH. Install uv (https://docs.astral.sh/uv/getting-started/installation/),"
  warn "then re-run this script or open Neovim to auto-install ruff."
fi

info "Done. Open a new shell (or 'source ~/.zshrc') to pick up PATH and shell config."
info "Neovim plugins and LSP servers install automatically on first launch."
