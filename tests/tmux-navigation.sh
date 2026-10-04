#!/usr/bin/env bash
set -euo pipefail
repo=$(cd "$(dirname "$0")/.." && pwd)
root=$(mktemp -d)
socket="$root/socket"
trap 'tmux -S "$socket" kill-server 2>/dev/null || true; rm -rf "$root"' EXIT
# Load only tmux-fzf, never continuum or personal session state.
mkdir -p "$root/.config/tmux/plugins/tpm"
ln -s "$repo/.config/tmux/themes" "$root/.config/tmux/themes"
ln -s "$repo/.config/tmux/scripts" "$root/.config/tmux/scripts"
ln -s "$repo/.config/tmux/plugins/tmux-fzf" "$root/.config/tmux/plugins/tmux-fzf"
printf '#!/bin/sh\nexec "$HOME/.config/tmux/plugins/tmux-fzf/main.tmux"\n' > "$root/.config/tmux/plugins/tpm/tpm"
chmod +x "$root/.config/tmux/plugins/tpm/tpm"
HOME="$root" tmux -S "$socket" -f /dev/null new-session -d -s navigation 'sleep 300'
tmux_test() { tmux -S "$socket" "$@"; }
tmux_test set-environment -g HOME "$root"
for iteration in 1 2; do
  output=$(tmux_test source-file "$repo/.config/tmux/tmux.conf" 2>&1)
  [[ -z "$output" ]] || { printf '%s\n' "$output"; exit 1; }
  [[ $(tmux_test list-keys -T prefix s) == *"TMUX_FZF_CLIENT='#{client_tty}'"*'scripts/session-switcher'* ]]
  [[ $(tmux_test list-keys -T prefix F) == *'tmux-fzf/main.sh'* ]]
  [[ $(tmux_test list-keys -T prefix b) == *'workmux sidebar'* ]]
  [[ $(tmux_test show-environment -g TMUX_FZF_PREVIEW) == 'TMUX_FZF_PREVIEW=0' ]]
  options=$(tmux_test show-environment -g TMUX_FZF_OPTIONS)
  [[ "$options" == *'-p -w 70% -h 45%'*'--border=rounded'*'bg+:#81A1C1'* ]]
done
# Check that fzf accepts the styling arguments, without opening a live popup.
options=${options#TMUX_FZF_OPTIONS=}
options=${options#'-p -w 70% -h 45% '}
# Intentional word splitting: these plugin options contain no quoted whitespace.
# shellcheck disable=SC2086
[[ $(printf 'workmux-test\n' | fzf $options --filter=workmux) == workmux-test ]]
# Exercise the display-only name coloring with real fzf and a stub plugin entry.
mkdir -p "$root/stub/.config/tmux/plugins/tmux-fzf/scripts"
cat > "$root/stub/.config/tmux/plugins/tmux-fzf/scripts/session.sh" <<'SH'
#!/bin/sh
[ "$1" = switch ] || exit 1
printf '%s' "$FZF_DEFAULT_OPTS" > "$HOME/options"
exec fzf --filter='project with spaces'
SH
chmod +x "$root/stub/.config/tmux/plugins/tmux-fzf/scripts/session.sh"
row='project with spaces: 2 windows (attached)'
[[ $(printf '%s\n' "$row" | HOME="$root/stub" "$repo/.config/tmux/scripts/session-switcher") == "$row" ]]
grep -F "$(printf '\033[38;2;163;190;140m{1}\033[0m:{2..}')" "$root/stub/options" >/dev/null
printf 'tmux-navigation: bindings, reload, theme and uncolored session selection passed\n'
