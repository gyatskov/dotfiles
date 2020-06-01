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

for component in */; do
    if [[ -d $component ]]; then
        echo "Installing '$component'"
        stow -d "$PWD" -t "$HOME" "$component" --adopt
    fi
done

