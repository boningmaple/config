#!/bin/bash

# check-command-exists()
# --------------------
# Checks if a given command is available on the system.
#
# Arguments:
#   $1: The command name to check (e.g., 'brew', 'git', 'docker').
#
# Returns:
#   0 if the command exists, 1 otherwise.
#
# Usage:
#   if check-command-exists "brew"; then
#       echo "Homebrew is available."
#   fi
check-command-exists() {
    local command_name="$1"

    if command -v "$command_name" &>/dev/null; then
        return 0
    else
        return 1
    fi
}

# require-command()
# --------------------
# Checks for a command and prints an error message, then exits the script
# if the command is not found. Useful for critical prerequisites.
#
# Arguments:
#   $1: The command name to check.
#
# Returns:
#   0 if the command exists, 1 otherwise.
#
# Usage:
#   require-command "brew"
require-command() {
    local command_name="$1"

    if ! check-command-exists "$command_name"; then
        echo "❌ ERROR: Required command '${command_name}' is not installed or not found in your PATH."
        echo "Please install '${command_name}' before continuing."
        exit 1
    fi
}
