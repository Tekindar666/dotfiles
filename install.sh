#!/usr/bin/env bash

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { printf "%b[INFO]%b %s\n" "$BLUE" "$NC" "$1"; }
log_success() { printf "%b[SUCCESS]%b %s\n" "$GREEN" "$NC" "$1"; }
log_warning() { printf "%b[WARNING]%b %s\n" "$YELLOW" "$NC" "$1"; }
log_error() { printf "%b[ERROR]%b %s\n" "$RED" "$NC" "$1" >&2; }

usage() {
    cat <<'EOF'
Usage: ./install.sh [--skip-packages]

Options:
  --skip-packages  Link configuration without installing system packages.
  -h, --help       Show this help message.
EOF
}

SKIP_PACKAGES=false
while [[ $# -gt 0 ]]; do
    case "$1" in
        --skip-packages)
            SKIP_PACKAGES=true
            ;;
        -h | --help)
            usage
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            usage >&2
            exit 1
            ;;
    esac
    shift
done

case "$(uname -s)" in
    Darwin)
        PLATFORM="macos"
        ;;
    Linux)
        if [[ ! -f /etc/arch-release ]] || ! command -v pacman &>/dev/null; then
            log_error "Linux support currently requires Arch Linux and pacman."
            exit 1
        fi
        PLATFORM="arch"
        ;;
    *)
        log_error "Unsupported operating system: $(uname -s)"
        exit 1
        ;;
esac

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

backup_if_exists() {
    local path="$1"
    if [[ -e "$path" && ! -L "$path" ]]; then
        local backup_path="${path}.backup.$(date +%Y%m%d_%H%M%S)"
        log_warning "Backing up $path to $backup_path"
        mv "$path" "$backup_path"
    fi
}

link_path() {
    local source="$1"
    local target="$2"

    if [[ ! -e "$source" && ! -L "$source" ]]; then
        log_error "Missing source: $source"
        exit 1
    fi

    mkdir -p "$(dirname "$target")"
    backup_if_exists "$target"
    ln -sfn "$source" "$target"
    log_success "Linked $target"
}

install_formula() {
    local package="$1"
    if brew list --formula "$package" &>/dev/null; then
        log_success "$package already installed"
        return
    fi

    log_info "Installing $package..."
    brew install "$package"
}

install_cask() {
    local package="$1"
    if brew list --cask "$package" &>/dev/null; then
        log_success "$package already installed"
        return
    fi

    log_info "Installing $package..."
    brew install --cask "$package"
}

install_macos_packages() {
    if ! command -v brew &>/dev/null; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        log_success "Homebrew already installed"
    fi

    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    local formulae=(
        bat
        fastfetch
        fd
        fzf
        gh
        git-delta
        git-lfs
        jq
        lazygit
        neovim
        node@22
        openjdk@17
        pnpm
        ripgrep
        starship
        tmux
        tree
        raine/workmux/workmux
        zoxide
        zsh-autosuggestions
        zsh-syntax-highlighting
    )
    local casks=(
        font-jetbrains-mono-nerd-font
        ghostty
    )

    local package
    for package in "${formulae[@]}"; do
        install_formula "$package"
    done
    for package in "${casks[@]}"; do
        install_cask "$package"
    done
}

install_arch_packages() {
    local packages=(
        base-devel
        bat
        fastfetch
        fd
        fzf
        ghostty
        git
        git-delta
        github-cli
        jq
        lazygit
        neovim
        nodejs-lts-jod
        pnpm
        ripgrep
        starship
        tmux
        tree
        ttf-jetbrains-mono-nerd
        unzip
        wl-clipboard
        zoxide
        zsh
        zsh-autosuggestions
        zsh-syntax-highlighting
    )
    local pacman_command=(pacman)

    if [[ $EUID -ne 0 ]]; then
        if ! command -v sudo &>/dev/null; then
            log_error "sudo is required to install Arch packages."
            exit 1
        fi
        pacman_command=(sudo pacman)
    fi

    log_info "Updating Arch and installing required packages..."
    "${pacman_command[@]}" -Syu --needed "${packages[@]}"

    if ! command -v workmux &>/dev/null; then
        log_warning "Install workmux-bin from the AUR separately to enable Workmux."
    fi
}

log_info "Detected platform: $PLATFORM"
if [[ "$SKIP_PACKAGES" == true ]]; then
    log_warning "Skipping package installation"
elif [[ "$PLATFORM" == "macos" ]]; then
    install_macos_packages
else
    install_arch_packages
fi

log_info "Linking dotfiles from $SCRIPT_DIR..."
for item in "$SCRIPT_DIR/.config"/*; do
    [[ -e "$item" ]] || continue
    link_path "$item" "$HOME/.config/$(basename "$item")"
done

link_path "$SCRIPT_DIR/.config/zsh/entrypoints/$PLATFORM.zsh" "$HOME/.zshrc"
link_path "$SCRIPT_DIR/.gitconfig" "$HOME/.gitconfig"

if [[ "$PLATFORM" == "macos" ]]; then
    link_path "$SCRIPT_DIR/.config/lazygit/config.yml" "$HOME/Library/Application Support/lazygit/config.yml"
fi

if [[ ! -d "$HOME/.config/tmux/plugins/tpm" ]]; then
    log_info "Installing Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
else
    log_success "Tmux Plugin Manager already installed"
fi

log_info "Installing tmux plugins..."
"$HOME/.config/tmux/plugins/tpm/bin/install_plugins"

log_success "Installation complete."
printf "  1. Restart your terminal or run: source ~/.zshrc\n"
if [[ "$PLATFORM" == "arch" ]] && command -v zsh &>/dev/null; then
    printf "  2. To make Zsh your login shell, run: chsh -s \"$(command -v zsh)\"\n"
fi
