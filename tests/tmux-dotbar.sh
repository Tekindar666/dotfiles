#!/usr/bin/env bash
set -euo pipefail
repo=$(cd "$(dirname "$0")/.." && pwd)
root=$(mktemp -d)
socket="$root/socket"
cleanup() {
  tmux -S "$socket" kill-server 2>/dev/null || true
  rm -rf "$root"
}
trap cleanup EXIT
# No real plugins: in particular, do not run continuum's session restore.
mkdir -p "$root/.config/tmux/plugins/tpm"
printf '#!/bin/sh\nexit 0\n' > "$root/.config/tmux/plugins/tpm/tpm"
chmod +x "$root/.config/tmux/plugins/tpm/tpm"
ln -s "$repo/.config/tmux/themes" "$root/.config/tmux/themes"
ln -s "$repo/.config/tmux/scripts" "$root/.config/tmux/scripts"
HOME="$root" tmux -S "$socket" -f /dev/null new-session -d -s theme 'sleep 300'
tmux_test() { tmux -S "$socket" "$@"; }
tmux_test set-environment -g HOME "$root"
for iteration in 1 2; do
  output=$(tmux_test source-file "$repo/.config/tmux/tmux.conf" 2>&1)
  [[ -z "$output" ]] || { printf '%s\n' "$output"; exit 1; }
  [[ $(tmux_test show-options -gqv status-style) == 'bg=default,fg=#475266' ]]
  [[ $(tmux_test show-options -gwqv window-status-current-style) == default ]]
  [[ $(tmux_test show-options -gwqv window-status-separator) == ' • ' ]]
  [[ $(tmux_test show-options -gqv status-right) == *'fg=#565B66'*'git-branch #{q:pane_current_path}'* ]]
  [[ $(tmux_test show-options -gqv prefix) == C-a ]]
done
# Exercise the exact command substitution path quoting through tmux's formatter.
dir="$root/repo with spaces and 'quote"
mkdir -p "$dir" "$root/not-a-repo"
git -C "$dir" init -q -b feature/dotbar
[[ $("$repo/.config/tmux/scripts/git-branch" "$dir") == feature/dotbar ]]
[[ -z $("$repo/.config/tmux/scripts/git-branch" "$root/not-a-repo") ]]
tmux_test new-window -d -t theme: -n git -c "$dir" 'sleep 300'
command=$(tmux_test display-message -p -t theme:git "$repo/.config/tmux/scripts/git-branch #{q:pane_current_path}")
[[ $(bash -c "$command") == feature/dotbar ]]
git -C "$dir" -c user.name=Test -c user.email=test@example.invalid commit -qm initial --allow-empty
git -C "$dir" checkout -q --detach
[[ -z $("$repo/.config/tmux/scripts/git-branch" "$dir") ]]
printf 'tmux-dotbar: config/reload, transparency, branch quoting and empty states passed\n'
