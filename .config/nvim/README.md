# Neovim Config

Built on [LazyVim](https://lazyvim.github.io).

## Structure

```
lua/
├── config/
│   ├── keymaps.lua   -- custom keybindings
│   ├── options.lua   -- vim options / globals
│   ├── lazy.lua      -- lazy.nvim bootstrap
│   └── autocmds.lua  -- autocommands
└── plugins/
    ├── ui.lua        -- colorscheme, statusline, bufferline, color highlighting
    ├── editor.lua    -- navigation, file browser, formatting, markdown rendering
    ├── git.lua       -- gitsigns, zdiff
    ├── lsp.lua       -- LSP, completion, Mason tools
    ├── pi.lua        -- Sidekick CLI integration
    └── extra.lua     -- language-specific (Typst)
```

## Plugins

### UI
- **nordic.nvim** — Nord-based colorscheme with Nordic Blur cursor, active-line, and diagnostic gutter colors
- **lualine.nvim** — minimal statusline matching tmux Nord palette
- **dropbar.nvim** — keyboard-driven path and symbol breadcrumbs (`<leader>;`, `[;`, `];`)
- **bufferline.nvim** — minimal tab/buffer line, no icons or close buttons
- **nvim-highlight-colors** — inline color swatches with Tailwind support
- **mini.icons** — icon provider

### Editor
- **oil.nvim** — file browser (`-` to open), hidden files shown
- **flash.nvim** — jump/treesitter motion (`s` / `S` / `r` / `R`)
- **nvim-surround** — surround text objects (`gsa`, `gsd`, `gsr`)
- **nvim-ufo** — LSP-backed code folding (`zR` / `zM`)
- **vim-tmux-navigator** — `<C-h/j/k/l>` across nvim splits and tmux panes
- **trouble.nvim** — diagnostics (`<leader>x*`), wrapped plain-text quickfix reading sets (`<leader>xq`), and file outline (`<leader>cs`)
- **render-markdown.nvim** — explicitly disabled; Markdown syntax highlighting and language support remain enabled
- **snacks.nvim** — floating picker with preview hidden; relative import-path copying (`<leader>fi`)
- **conform.nvim** — formatter (`<leader>f` and automatic formatting); Oxfmt for JS/TS, including JSX/TSX. Uses project-local Oxfmt when available, with Mason as a fallback.
- **nvim-lint** — Oxlint diagnostics for JS/TS on save. ESLint integration has been removed; existing projects must adopt Oxlint explicitly if they need equivalent lint rules.
- **TypeScript presets** — copy the configs from [`templates/typescript`](../../templates/typescript/README.md) into new projects. They are not applied globally.

### Agent
- **sidekick.nvim** — tmux-backed AI CLI integration; `<leader>aa` toggles the CLI, `<leader>ap` selects a saved prompt, and `<leader>ai` enters a custom prompt. Next Edit Suggestions and Ctrl+. mappings are disabled.

### Git
- **gitsigns.nvim** — sign column + inline current-line blame
- **zdiff.nvim** — single-buffer diff viewer (`<leader>zd` for uncommitted changes, `<leader>zD` against `origin/develop`). LazyVim’s Lazygit shortcuts are removed.

### LSP / Completion
- **blink.cmp** — completion with automatic type/documentation details (super-tab preset, no ghost text)
- **nvim-lspconfig** — LSP config; inlay hints off, virtual text off, underline diagnostics
- **Mason** extras include `shellcheck`, `shfmt`, `jdtls`, `checkstyle`, `oxlint`, and `oxfmt`. After saving and restarting Neovim, use `:MasonInstall oxlint oxfmt` if they aren't installed yet. Previously installed ESLint/Prettier binaries are not automatically uninstalled.
- **tsgo** — native TypeScript/JS language server (LSP support is still in progress upstream)

### Extra
- **typst-preview.nvim** — live Typst preview
