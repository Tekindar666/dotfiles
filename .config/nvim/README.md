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
│   └── extra.lua     -- language-specific (Typst)
└── util/
    ├── eslint.lua -- flat-config detection for conform
    ├── pi.lua     -- Pi bridge and Neovim context integration
    ├── pi-prompt.lua -- cursor-relative multiline prompt composer
    └── pi-harpoon.lua -- replace/clear Pi-managed working-set marks
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
- **trouble.nvim** — diagnostics/quickfix panel (`<leader>x*`)
- **render-markdown.nvim** — explicitly disabled; Markdown syntax highlighting and language support remain enabled
- **snacks.nvim** — floating picker with preview hidden; relative import-path copying (`<leader>fi`); hidden + Git-ignored file search (`<leader>fh`, includes `.git/`, hidden files only outside Git)
  - `<leader>fh` searches the project root using fd/fdfind and Git, including ignored dependency/build directories. Ordinary visible files are excluded. Test with `nvim --headless -u NONE -l tests/nvim-hidden-files.lua`.
- **conform.nvim** — formatter (`<leader>f`); ESLint flat-config aware for JS/TS

### Agent
- **Pi** — tmux-local agent bridge with Neovim context (`<leader>pa`)

### Git
- **gitsigns.nvim** — sign column + inline current-line blame
- **diffview.nvim** — git diff/history viewer (`<leader>gD/gH/gr`)

### LSP / Completion
- **blink.cmp** — completion with automatic type/documentation details (super-tab preset, no ghost text)
- **nvim-lspconfig** — LSP config; inlay hints off, virtual text off, underline diagnostics
- **Mason** extras: `shellcheck`, `shfmt`, `tailwindcss-language-server`, `css-lsp`, `jdtls`, `checkstyle`
- **tsgo** — native TypeScript/JS language server (LSP support is still in progress upstream)

### Extra
- **typst-preview.nvim** — live Typst preview

## Pi prompt composer

`<leader>pp` opens an editable, cursor-relative float with LSP-style positioning and a rounded border. It starts in Insert mode; Enter inserts a newline, Escape returns to Normal mode, and normal Vim editing/undo works. Normal-mode `q` closes it without sending. Reopening restores unfinished text, undo history, and the original source context. Text stays in memory only, not across Neovim restarts. Delete all text and close to discard a draft and start with fresh context next time.

- `<C-s>` in Normal or Insert mode appends the prompt to Pi's draft. While awaiting acknowledgement, the composer is temporarily non-editable and duplicate confirmation is ignored. Success clears/closes it; failures retain the text. After a timeout/disconnect, check Pi's draft before retrying: the append may have succeeded even if its acknowledgement was lost. No automatic retries.
- Normal-mode `<leader>pp` sends prompt text without file/cursor/revision metadata. Visual-mode `<leader>pp` attaches the original source file, selection coordinates, and Neovim revision (`changedtick`), captured before opening. Selected code is not copied; Pi can read the live buffer separately.
- `<leader>pa` explicitly attaches the current buffer location/selection. `<leader>pd` and `<leader>ph` still append diagnostics and LSP hover with source metadata.
- `<leader>p<Enter>` submits the assembled **Pi draft**, not unsent text still in the composer. Pi's own Enter behavior is unchanged.

Restart Neovim to load the composer after saving any work. No Pi extension reload is needed for this change. Test with:

```bash
nvim --headless -u NONE -l tests/nvim-pi-prompt.lua
nvim --headless -u NONE -l tests/nvim-pi.lua
```

The composer test also launches an isolated terminal-backed Neovim (no personal config or shada) to check Insert mode, multiline input, close/reopen, and placement near screen edges/on small terminals. Manually check appearance with your normal theme and verify Ctrl-S reaches Neovim through your terminal/tmux.

## Pi / Harpoon working sets

Pi can publish the current reading/design/implementation files to the default Harpoon list. Use `<leader>h` for the menu and `<leader>1`–`9` to select files. `<leader>H` still adds personal marks.

Publishing replaces only Pi-managed marks, filling available slots in requested order. Personal marks keep their shortcut positions; files already bookmarked personally aren't duplicated or taken over. Clearing a completed working set preserves personal marks, comments, buffers, and unsaved edits. Ownership persists with Harpoon data across reconnects/restarts.

Keep Pi and Neovim in the same working directory, normally the worktree root. Close the Harpoon menu before publishing so its editable contents cannot overwrite a newer working set. Marks remain file navigation, not fixed line annotations; keep explanations beside the code and use quickfix for precise diagnostics/review findings.

After updating both the Pi bridge and this config, reload Pi and restart Neovim. Test without touching personal marks:

```bash
nvim --headless -u NONE -l tests/nvim-pi.lua
nvim --headless -u NONE -l tests/nvim-pi-harpoon.lua
```

The second test needs the installed Harpoon/plenary plugins; `NVIM_PLUGIN_DIR` can override their parent directory. Persistent test data is isolated and removed afterward.
