source "$HOME/.config/zsh/platform/arch.zsh"
source "$HOME/.config/zsh/shared.zsh"

# bun completions
[ -s "/home/ed/.bun/_bun" ] && source "/home/ed/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
