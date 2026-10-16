#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <macos|arch>" >&2
    exit 1
fi

EXPECTED_PLATFORM="$1"
case "$(uname -s)" in
    Darwin) ACTUAL_PLATFORM="macos" ;;
    Linux) ACTUAL_PLATFORM="arch" ;;
    *)
        echo "Unsupported test platform: $(uname -s)" >&2
        exit 1
        ;;
esac

if [[ "$EXPECTED_PLATFORM" != "$ACTUAL_PLATFORM" ]]; then
    echo "Expected $EXPECTED_PLATFORM but detected $ACTUAL_PLATFORM" >&2
    exit 1
fi

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_HOME="$(mktemp -d)"
trap 'rm -rf "$TEST_HOME"' EXIT
export XDG_CONFIG_HOME="$TEST_HOME/.config"

for file in \
    "$REPO_DIR/install.sh" \
    "$REPO_DIR/tests/install-smoke.sh" \
    "$REPO_DIR/tests/pi-install-smoke.sh"; do
    bash -n "$file"
done

for file in \
    "$REPO_DIR/.config/zsh"/*.zsh \
    "$REPO_DIR/.config/zsh/entrypoints"/*.zsh \
    "$REPO_DIR/.config/zsh/platform"/*.zsh; do
    zsh -n "$file"
done

HOME="$TEST_HOME" "$REPO_DIR/install.sh" --skip-packages
HOME="$TEST_HOME" "$REPO_DIR/install.sh" --skip-packages

for source in "$REPO_DIR/.config"/*; do
    [[ "$source" == "$REPO_DIR/.config/git" ]] && continue
    target="$TEST_HOME/.config/$(basename "$source")"
    if [[ ! -L "$target" || "$(readlink "$target")" != "$source" ]]; then
        echo "Invalid config link: $target" >&2
        exit 1
    fi
done

expected_zsh="$REPO_DIR/.config/zsh/entrypoints/$EXPECTED_PLATFORM.zsh"
if [[ ! -L "$TEST_HOME/.zshrc" || "$(readlink "$TEST_HOME/.zshrc")" != "$expected_zsh" ]]; then
    echo "Invalid Zsh entrypoint" >&2
    exit 1
fi

if [[ ! -L "$TEST_HOME/.gitconfig" || "$(readlink "$TEST_HOME/.gitconfig")" != "$REPO_DIR/.gitconfig" ]]; then
    echo "Invalid Git config link" >&2
    exit 1
fi

if [[ "$EXPECTED_PLATFORM" == "macos" ]]; then
    lazygit_target="$TEST_HOME/Library/Application Support/lazygit/config.yml"
    if [[ ! -L "$lazygit_target" || "$(readlink "$lazygit_target")" != "$REPO_DIR/.config/lazygit/config.yml" ]]; then
        echo "Invalid macOS LazyGit link" >&2
        exit 1
    fi
elif [[ -e "$TEST_HOME/Library" || -L "$TEST_HOME/Library" ]]; then
    echo "Arch install created a macOS Library path" >&2
    exit 1
fi

for path in \
    "$TEST_HOME/.claude" \
    "$TEST_HOME/.config/karabiner" \
    "$TEST_HOME/.config/opencode" \
    "$TEST_HOME/.config/zed" \
    "$TEST_HOME/.config/spicetify" \
    "$TEST_HOME/.config/sketchybar"; do
    if [[ -e "$path" || -L "$path" ]]; then
        echo "Installer created excluded path: $path" >&2
        exit 1
    fi
done

if find "$TEST_HOME" -name '*.backup.*' -print -quit | grep -q .; then
    echo "Second install created unexpected backups" >&2
    exit 1
fi

HOME="$TEST_HOME" zsh -fc 'source "$HOME/.zshrc"; [[ "$EDITOR" == "nvim" ]]'

[[ "$(readlink "$TEST_HOME/.pi/agent/settings.json")" == "$REPO_DIR/.pi/agent/settings.json" ]]
[[ "$(readlink "${XDG_CONFIG_HOME:-$TEST_HOME/.config}/git/ignore")" == "$REPO_DIR/.config/git/ignore" ]]
bash "$REPO_DIR/tests/pi-install-smoke.sh"

echo "$EXPECTED_PLATFORM install smoke test passed"
