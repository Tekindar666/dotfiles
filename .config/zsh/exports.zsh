# Editor
export EDITOR='nvim'
export VISUAL='nvim'
export ENABLE_IDE_INTEGRATION=true

# Global paths
export PATH="$HOME/.local/bin:$PATH"
[[ -d "$HOME/downloads/git-fuzzy/bin" ]] && export PATH="$HOME/downloads/git-fuzzy/bin:$PATH"
[[ -d "$HOME/.lmstudio/bin" ]] && export PATH="$PATH:$HOME/.lmstudio/bin"

if [[ -r "$HOME/.config/lsd/ls-colors" ]]; then
    export LS_COLORS="$(< "$HOME/.config/lsd/ls-colors")"
fi

# API keys / private environment
[[ -f "$HOME/.env" ]] && source "$HOME/.env"

# GitHub token (sourced from gh CLI keychain) for MCP and tools
command -v gh &>/dev/null && export GITHUB_TOKEN="$(gh auth token 2>/dev/null)"
