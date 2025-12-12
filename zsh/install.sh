#!/bin/bash

SCRIPT_PATH=$(readlink -f "${BASH_SOURCE[0]}")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
LIB_PATH="$SCRIPT_DIR/../lib.sh"

# **CRITICAL ERROR CHECK:** Check if the library file exists at the calculated path.
if [[ ! -f "$LIB_PATH" ]]; then
    echo "❌ CRITICAL ERROR: Required library file 'lib.sh' not found."
    echo "Expected location: $LIB_PATH"
    echo "Please ensure 'lib.sh' is placed in the parent directory of this script (zsh/)."
    echo "Current SCRIPT_DIR: $SCRIPT_DIR"
    exit 1 # Exit the script immediately upon failure
fi

# shellcheck source=../lib.sh
source "$LIB_PATH"

# Array of some formulae packages to install/check, including:
# - Vim, Neovim
# - Zsh plugins: zsh-autosuggestions, zsh-syntax-highlighting, zoxide, starship
# - CLI: fzf, tree, tokei, fastfetch
# - Rust: rustup
# - JavaScript: fnm
PACKAGES=("vim" "neovim" "zsh-autosuggestions" "zsh-syntax-highlighting" "zoxide" "starship" "rustup" "fnm" "fzf" "tree" "tokei" "fastfetch")

main() {
    echo "🚀 Starting Zsh configuration..."
    install-packages
    configure-zsh
    echo "🎉 Completed."
}

install-packages() {
    echo "🚀 Installing packages..."
    case $OSTYPE in
    darwin*)
        mac-install-packages
        ;;
    # linux*)
    #     linux-install-zsh-plugins
    #     ;;
    *)
        echo "❌ Unsupported OS type: $OSTYPE"
        exit 1
        ;;
    esac
}

mac-install-packages() {
    # The script will stop here if Homebrew is not installed.
    require-command "brew"

    # Loop through each package and install only if needed
    for package in "${PACKAGES[@]}"; do
        # Check if the package is already installed using 'brew list'
        # 'brew list --formula' lists only formula packages (like these).
        if brew list --formula | grep -q "^${package}$"; then
            echo "  ✅ ${package} is already installed."
        else
            # If not installed, install it.
            echo "  ✨ Installing ${package}..."

            if brew install "${package}" &>/dev/null; then
                # Print a success message after installation.
                echo "  ✅ Successfully installed ${package}."
            else
                # Handle installation failure
                echo "  ❌ Failed to install ${package}. Please check the Homebrew output."
                # Don't exit the script, just move to the next package.
            fi
        fi

        if [ "$package" = "rustup" ]; then
            echo "    🚀 Initializing rustup with default stable toolchain..."
            if "$package" default stable &>/dev/null; then
                echo "    ✅ rustup initialized successfully."
            else
                echo "    ⚠️ rustup initialization failed."
            fi
        fi
    done
}

configure-zsh() {
    echo "🚀 Configuring Zsh..."

    # 1. Define paths
    local source_file="$SCRIPT_DIR/zsh-config.zsh"
    local config_dir="$HOME/.config/zsh"
    local config_file="$config_dir/zsh-config.zsh"
    local zshrc_file="$HOME/.zshrc"

    local activation_line="source \"$config_file\""
    local marker_line="# >>> ZSH CONFIGURATION START (via mac_config_script) >>>"
    local end_marker="# <<< ZSH CONFIGURATION END (via mac_config_script) <<<"

    # Check if the source file exists before trying to copy
    if [[ ! -f "$source_file" ]]; then
        echo "  ❌ ERROR: Source configuration file '${source_file}' not found. Cannot proceed with activation."
        exit 1
    fi

    # Create target directory if it doesn't exist
    if [[ ! -d "$config_dir" ]]; then
        echo "  ✨ Creating directory: ${config_dir}"
        mkdir -p "$config_dir"
    fi

    # Copy the configuration file
    cp "$source_file" "$config_file"
    echo "  ✅ Copied ${source_file} to ${config_file}"

    # Check if the config is already sourced by looking for the marker line
    if grep -qF "$marker_line" "$zshrc_file" 2>/dev/null; then
        echo "  ✅ Configuration is already sourced in ~/.zshrc"
    else
        echo "  ✨ Adding activation block to ~/.zshrc..."
        {
            echo ""
            echo "$marker_line"
            echo "$activation_line"
            echo "$end_marker"
        } >>"$zshrc_file"
        echo "  ✅ Successfully updated ~/.zshrc."
    fi
}

main
