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

Hyprland desktop configuration is maintained in [hyprland-dotfiles](https://github.com/Tekindar666/hyprland-dotfiles). Karabiner, OpenCode, Zed, Claude, and Pi configuration are also managed outside this public repository.

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
