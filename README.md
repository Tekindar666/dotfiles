# Dotfiles

Shared configuration for macOS and Arch Linux.

## Branches

- **main** — active cross-platform configuration
- **macos** — historical macOS snapshot
- **hyprland** — historical Hyprland snapshot retained for reference; active desktop configuration lives in [hyprland-dotfiles](https://github.com/Tekindar666/hyprland-dotfiles)

New work belongs on `main`. The historical branches are retained for reference.

## Tracked configuration

- Ghostty
- Kitty
- Neovim
- tmux
- Zsh and Starship
- Fastfetch
- gh-dash
- LazyGit
- Git
- Workmux
- Pi (personal settings, skills, extensions, and theme)

Hyprland desktop configuration is maintained in [hyprland-dotfiles](https://github.com/Tekindar666/hyprland-dotfiles). Karabiner, OpenCode, Zed, and Claude configuration are managed outside this public repository. Pi credentials and runtime state remain machine-local.

## Install

```bash
git clone git@github.com:Tekindar666/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The installer:

1. Detects macOS or Arch Linux.
2. Installs packages with Homebrew or pacman.
3. Symlinks tracked configuration into `$HOME`.
4. Selects the matching Zsh entrypoint.
5. Installs Tmux Plugin Manager when missing.

Arch installation performs a full system upgrade with `pacman -Syu` to avoid an unsupported partial upgrade.
Install `workmux-bin` from the AUR separately on Arch; the macOS installer installs Workmux through Homebrew.

To link configuration without installing packages:

```bash
./install.sh --skip-packages
```

Existing regular files or directories are moved to timestamped backups before linking.

## Neovim and Pi

The Neovim plugin is installed from [Tekindar666/pi.nvim](https://github.com/Tekindar666/pi.nvim) through lazy.nvim. The Pi companion extension currently lives in this repository; do not install a second copy through Pi. Run Pi and Neovim in the same tmux window.

Personal `<leader>p` mappings, statusline styling, and the local Pi companion tests live here; Neovim bridge implementation lives in the plugin repository. After migration, save your work and restart both applications. Run `nvim --headless -u NONE -l tests/nvim-pi.lua` to check the personal mappings and package configuration.

To migrate only Pi without reinstalling terminal or system packages, run `./install.sh --pi-only`. See [Pi setup and validation](docs/pi.md). Credentials, sessions, and installed packages are not copied into this repository.

## Tmux navigation

The prefix is **Ctrl-A**:

- **prefix+s**: tmux-fzf session switcher (includes open Workmux sessions).
- **prefix+F**: full tmux-fzf menu for sessions, windows, panes, and other actions.
- **prefix+b**: toggle the Workmux agent sidebar across all sessions.

The picker uses the Nord/cyan theme, a 70% × 45% popup, and hidden previews.
Workmux owns worktree creation/opening; the picker navigates existing sessions.
Reload tmux configuration with **prefix+r** after changes.

## Workmux

Global defaults live in `.config/workmux/config.yaml`, symlinked to
`~/.config/workmux/config.yaml` through the configuration directory. Pi is the default agent.
Keep project-specific hooks, file operations, and pane layouts in each repository's
`.workmux.yaml` (`workmux init` creates it).

Existing Worktrunk installations and worktrees are not removed by the installer.

## Zsh layout

```text
.config/zsh/
├── entrypoints/
│   ├── arch.zsh
│   └── macos.zsh
├── platform/
│   ├── arch.zsh
│   └── macos.zsh
├── shared.zsh
└── shared modules
```

The installer links the correct entrypoint to `~/.zshrc`; shell startup does not need to detect the operating system.

## Notes

- Credentials and environment variables belong in `~/.env`, which is not tracked.
- Local application state should not be added to this repository.
- Hyprland configuration is maintained separately in [hyprland-dotfiles](https://github.com/Tekindar666/hyprland-dotfiles).
