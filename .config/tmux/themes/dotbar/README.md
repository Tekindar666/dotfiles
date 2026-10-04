# Local tmux-dotbar

Copied from https://github.com/vaaleyard/tmux-dotbar at
`2810226456ca24cfbbbf95cbe52049d752bd3780` (MIT; see LICENSE).

`dotbar.tmux` is the upstream script, kept locally for customization rather than
installed through TPM. It uses Nerd Font icons and the upstream Ayu foreground
colors, with a transparent background and a matching right-hand Git branch.
Detached HEAD and non-repository directories show no branch.
`tmux.conf` runs it before TPM so tmux-continuum can append its save command.
SSH icon-only mode is enabled in `tmux.conf` to preserve window names and avoid
shell interpolation of terminal-controlled pane titles.

Reload Pi with `/reload` in each running session **before** reloading tmux with
prefix + r. The old Pi extension's shutdown handler removes its custom tab
colors/hooks; the replacement only mirrors session names and sends completion
notifications. Workmux is unchanged. A Pi process not reloaded still runs the old
color integration.
