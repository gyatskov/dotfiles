#!/usr/bin/env bash
##
## @author Gennadij Yatskov
##
## Establishes symlinks to the configuration components using stow.
##
## Requirements:
##  * stow
##
## Usage:
##
##   cd dotfiles
##   ./install-all.sh
##

set -eu

if ! command -v stow; then
    echo "The following tool must be installed:"
    echo "stow"
    exit 1
fi

for component in */; do
    if [[ -d $component ]]; then
        echo "Installing '$component'"
        stow -d "$PWD" -t "$HOME" "$component" --adopt
    fi
done

