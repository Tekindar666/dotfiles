#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEST_ROOT"' EXIT
bash -n "$REPO_DIR/install.sh"

check_links() {
    local item
    for item in AGENTS.md keybindings.json mcp.json settings.json zentui.json extensions prompts skills themes; do
        [[ "$(readlink "$HOME/.pi/agent/$item")" == "$REPO_DIR/.pi/agent/$item" ]]
    done
    [[ ! -L "$HOME/.pi" && ! -L "$HOME/.pi/agent" ]]
    [[ "$(readlink "$HOME/.pi/web-search.json")" == "$REPO_DIR/.pi/web-search.json" ]]
    [[ "$(readlink "$XDG_CONFIG_HOME/git/ignore")" == "$REPO_DIR/.config/git/ignore" ]]
}

# Fresh install and rerun, including a non-default XDG config directory.
export HOME="$TEST_ROOT/fresh" XDG_CONFIG_HOME="$TEST_ROOT/xdg"
"$REPO_DIR/install.sh" --pi-only >/dev/null
"$REPO_DIR/install.sh" --pi-only >/dev/null
check_links
[[ -z "$(find "$HOME" "$XDG_CONFIG_HOME" -name '*.backup.*' -print)" ]]
[[ ! -e "$HOME/.zshrc" && ! -e "$HOME/.config/tmux" ]]

# Migration from another checkout: replace owned links, preserve private state.
export HOME="$TEST_ROOT/existing" XDG_CONFIG_HOME="$TEST_ROOT/existing/.config"
old_agent="$TEST_ROOT/old-checkout/.pi/agent"
mkdir -p "$old_agent" "$HOME/.pi/agent/sessions" "$HOME/.pi/agent/npm" "$XDG_CONFIG_HOME/git"
printf 'old instructions\n' > "$old_agent/AGENTS.md"
ln -s "$old_agent/AGENTS.md" "$HOME/.pi/agent/AGENTS.md"
ln -s "$old_agent/skills" "$HOME/.pi/agent/skills"
ln -s "$old_agent/APPEND_SYSTEM.md" "$HOME/.pi/agent/APPEND_SYSTEM.md"
ln -s "$old_agent/subagents.json" "$HOME/.pi/agent/subagents.json"
printf 'local settings\n' > "$HOME/.pi/agent/settings.json"
printf 'local ignore\n' > "$XDG_CONFIG_HOME/git/ignore"
printf '# local git config\n' > "$XDG_CONFIG_HOME/git/config"
for file in auth.json trust.json sessions/example.jsonl npm/local-state; do
    printf 'private state\n' > "$HOME/.pi/agent/$file"
done
"$REPO_DIR/install.sh" --pi-only >/dev/null
check_links
for retired in APPEND_SYSTEM.md subagents.json; do
    [[ ! -e "$HOME/.pi/agent/$retired" && ! -L "$HOME/.pi/agent/$retired" ]]
done
for file in auth.json trust.json sessions/example.jsonl npm/local-state; do
    [[ "$(< "$HOME/.pi/agent/$file")" == 'private state' ]]
done
[[ "$(< "$XDG_CONFIG_HOME/git/config")" == '# local git config' ]]
settings_backups=("$HOME/.pi/agent/settings.json.backup."*)
ignore_backups=("$XDG_CONFIG_HOME/git/ignore.backup."*)
[[ ${#settings_backups[@]} == 1 && "$(< "${settings_backups[0]}")" == 'local settings' ]]
[[ ${#ignore_backups[@]} == 1 && "$(< "${ignore_backups[0]}")" == 'local ignore' ]]

# Local retired resources and unrelated symlinks are not ours to remove.
printf 'local instructions\n' > "$HOME/.pi/agent/APPEND_SYSTEM.md"
ln -s "$TEST_ROOT/local-subagents.json" "$HOME/.pi/agent/subagents.json"
"$REPO_DIR/install.sh" --pi-only >/dev/null
[[ "$(< "$HOME/.pi/agent/APPEND_SYSTEM.md")" == 'local instructions' ]]
[[ "$(readlink "$HOME/.pi/agent/subagents.json")" == "$TEST_ROOT/local-subagents.json" ]]
[[ "$(find "$HOME" -name '*.backup.*' | wc -l | tr -d ' ')" == 2 ]]

mkdir "$TEST_ROOT/project"
git init -q "$TEST_ROOT/project"
git -C "$TEST_ROOT/project" check-ignore -q worktree-bg.md
printf 'Pi install smoke test passed\n'
