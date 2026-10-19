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
├── plugins/
│   ├── ui.lua        -- colorscheme, statusline, bufferline, color highlighting
│   ├── editor.lua    -- navigation, file browser, formatting, markdown rendering
│   ├── git.lua       -- gitsigns, diffview
│   ├── lsp.lua       -- LSP, completion, Mason tools
│   ├── pi.lua        -- standalone pi.nvim package
│   └── extra.lua     -- language-specific (Typst)
└── util/
    └── hidden-files.lua -- hidden-file picker support
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
- **snacks.nvim** — floating picker with preview hidden; relative import-path copying (`<leader>fi`); hidden + Git-ignored file search (`<leader>fh`, includes `.git/`, hidden files only outside Git)
  - `<leader>fh` searches the project root using fd/fdfind and Git, including ignored dependency/build directories. Ordinary visible files are excluded. Test with `nvim --headless -u NONE -l tests/nvim-hidden-files.lua`.
- **conform.nvim** — formatter (`<leader>f` and automatic formatting); Oxfmt for JS/TS, including JSX/TSX. Uses project-local Oxfmt when available, with Mason as a fallback.
- **nvim-lint** — Oxlint diagnostics for JS/TS on save. ESLint integration has been removed; existing projects must adopt Oxlint explicitly if they need equivalent lint rules.
- **TypeScript presets** — copy the configs from [`templates/typescript`](../../templates/typescript/README.md) into new projects. They are not applied globally.

### Agent
- **[pi.nvim](https://github.com/Tekindar666/pi.nvim)** — tmux-local agent bridge with Neovim context (`<leader>pa`). Install the companion extension with `pi install git:github.com/Tekindar666/pi.nvim`; run Pi and Neovim in the same tmux window. Bridge implementation/tests live in that repository; personal mappings and statusline styling stay here.

### Git
- **gitsigns.nvim** — sign column + inline current-line blame
- **diffview.nvim** — git diff/history viewer (`<leader>gD/gH/gr`)

### LSP / Completion
- **blink.cmp** — completion with automatic type/documentation details (super-tab preset, no ghost text)
- **nvim-lspconfig** — LSP config; inlay hints off, virtual text off, underline diagnostics
- **Mason** extras include `shellcheck`, `shfmt`, `jdtls`, `checkstyle`, `oxlint`, and `oxfmt`. After saving and restarting Neovim, use `:MasonInstall oxlint oxfmt` if they aren't installed yet. Previously installed ESLint/Prettier binaries are not automatically uninstalled.
- **tsgo** — native TypeScript/JS language server (LSP support is still in progress upstream)

### Extra
- **typst-preview.nvim** — live Typst preview

## Pi prompt composer

`<leader>pp` opens an editable, cursor-relative float with LSP-style positioning and a rounded border. It starts in Insert mode; Enter inserts a newline, Escape returns to Normal mode, and normal Vim editing/undo works. Normal-mode `q` closes it without sending. Reopening restores unfinished text, undo history, and the original source context. Text stays in memory only, not across Neovim restarts. Delete all text and close to discard a draft and start with fresh context next time.

- `<C-s>` in Normal or Insert mode appends the prompt to Pi's draft. While awaiting acknowledgement, the composer is temporarily non-editable and duplicate confirmation is ignored. Success clears/closes it; failures retain the text. After a timeout/disconnect, check Pi's draft before retrying: the append may have succeeded even if its acknowledgement was lost. No automatic retries.
- `<leader>pp` always attaches the original source file, cursor line/column, and Neovim revision (`changedtick`), captured before opening. Visual mode also attaches selection coordinates. Selected code is not copied; Pi can read the live buffer separately.
- `<leader>pa` explicitly attaches the current buffer location/selection. `<leader>pd` and `<leader>ph` still append diagnostics and LSP hover with source metadata.
- `<leader>ps` submits the assembled **Pi draft**, not unsent text still in the composer. Pi's own Enter behavior is unchanged.

After migrating to the package, save your work and restart both Neovim and Pi. Test with:

```bash
# In dotfiles:
nvim --headless -u NONE -l tests/nvim-pi.lua
# In a pi.nvim checkout:
npm test
```

The composer test also launches an isolated terminal-backed Neovim (no personal config or shada) to check Insert mode, multiline input, close/reopen, and placement near screen edges/on small terminals. Manually check appearance with your normal theme and verify Ctrl-S reaches Neovim through your terminal/tmux.

## Pi quickfix reading sets

Pi publishes small, ordered sets of exact code locations with plain-language explanations for an agreed walkthrough. Each set covers one state, transition, or focused concern. Open **`<leader>xq`**: Trouble wraps long explanations at word boundaries, displays them as plain text, and keeps supplied order instead of grouping/sorting by filename or severity. Enter jumps to the selected location. Both Trouble modes `quickfix` and `qflist` share these defaults; diagnostics, location lists, and symbols are unchanged.

Publishing replaces Pi's own quickfix list without overwriting unrelated lists, opening windows, moving the cursor, or saving/editing buffers. The tool supports append and an empty replacement to clear the Pi list. Use Trouble's `r` to refresh an already-open view. `:copen` opens the native quickfix window; `:colder` / `:cnewer` navigate list history. **`<leader>cs`** opens Trouble's file outline, while `zM` / `zR` close/open code folds. Pi does not control folding.

During walkthroughs, temporary `NOTE:` comments can explain the code beside the relevant lines. They stay uncommitted until reviewed for removal or conversion into durable rationale. Changing the reading set does not delete comments.

Harpoon remains your personal file working set: `<leader>h` opens its Snacks picker, `<leader>he` its editable menu, and `<leader>1`–`9` select marks. Pi's Harpoon publishing tool remains available only for explicit requests. It preserves personal slots and requires matching working directories and a closed editable menu; no bookmarks are automatically migrated or cleared.

Restart Neovim and Pi after saving your work to load both updated configurations. Test in isolated processes without touching personal marks:

```bash
# In dotfiles:
nvim --headless -u NONE -l tests/nvim-quickfix.lua
nvim --headless -u NONE -l tests/nvim-pi.lua
# In a pi.nvim checkout:
npm test
npm run test:harpoon
```

The display and Harpoon tests need the installed plugins; `NVIM_PLUGIN_DIR` can override their parent directory. Persistent test data is isolated and removed afterward.
