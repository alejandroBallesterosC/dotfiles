# nvim

Personal Neovim configuration, forked from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).

## What's Included

| Category       | Plugin                                                                 |
| :------------- | :--------------------------------------------------------------------- |
| Theme          | [monokai-pro](https://github.com/loctvl842/monokai-pro.nvim) (pro)    |
| File explorer  | [nvim-tree](https://github.com/nvim-tree/nvim-tree.lua)               |
| Statusline     | [lualine](https://github.com/nvim-lualine/lualine.nvim)               |
| Fuzzy finder   | [telescope](https://github.com/nvim-telescope/telescope.nvim)         |
| Completion     | [blink.cmp](https://github.com/saghen/blink.cmp) + LuaSnip           |
| LSP            | pyright, ruff, lua-language-server (auto-installed via Mason)          |
| Formatting     | [conform.nvim](https://github.com/stevearc/conform.nvim) — ruff (Python), stylua (Lua) |
| Git            | [gitsigns](https://github.com/lewis6991/gitsigns.nvim)                |
| Treesitter     | python, lua, bash, html, json, vim, markdown                          |
| Other          | which-key, mini.ai, mini.surround, guess-indent, todo-comments        |

## Requirements

- Neovim stable (latest)
- A [Nerd Font](https://www.nerdfonts.com/) installed and set in your terminal
- `git`, `make`, `gcc`, [ripgrep](https://github.com/BurntSushi/ripgrep), [fd](https://github.com/sharkdp/fd)
- `npm` (if using TypeScript LSPs), `python3` + `pip` (for Python tooling)

## Setup

```sh
git clone <this-repo> ~/.config/nvim
nvim
```

Lazy will auto-install all plugins on first launch. Mason will auto-install the configured language servers and formatters. Run `:Lazy` and `:Mason` to check status.

## Key Bindings

Leader is `<Space>`.

| Key              | Action                        |
| :--------------- | :---------------------------- |
| `<leader>e`      | Toggle file explorer          |
| `<leader>o`      | Focus file explorer           |
| `<leader>sf`     | Search files                  |
| `<leader>sg`     | Search by grep                |
| `<leader>sw`     | Search current word           |
| `<leader>sd`     | Search diagnostics            |
| `<leader>sh`     | Search help                   |
| `<leader>sk`     | Search keymaps                |
| `<leader>sc`     | Search commands               |
| `<leader>s.`     | Search recent files           |
| `<leader>sn`     | Search Neovim config files    |
| `<leader>/`      | Fuzzy search in buffer        |
| `<leader><leader>` | Find open buffers           |
| `<leader>f`      | Format buffer                 |
| `<leader>q`      | Diagnostic quickfix list      |
| `<leader>th`     | Toggle inlay hints            |
| `grn`            | LSP rename                    |
| `gra`            | Code action                   |
| `grd`            | Go to definition              |
| `grr`            | Go to references              |
| `gri`            | Go to implementation          |
| `grt`            | Go to type definition         |

Run `:WhichKey` or press `<Space>` and wait to discover more.

## Structure

```
init.lua                         — main config (options, keymaps, plugins)
lua/kickstart/plugins/           — optional kickstart plugin configs
lua/custom/plugins/              — custom plugin additions
```

## Credits

Based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) by TJ DeVries and contributors.
