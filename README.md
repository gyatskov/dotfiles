# Dotfiles #
Collection of configuration files for different software tools.
Each program configuration is mapped to one directory in 
the repository.

# Supported tools and applications #
Shells
 * zsh
 * bash

Terminal multiplexers
 * tmux

Graphical terminal emulators
 * terminator
 * alacritty

Debuggers
 * gdb

Editors
 * vim
 * nvim

IDEs
 * vscode

Window managers
 * Xserver
 * dconf

# Installation #
To install (stow) all of the configurations, run `install-all.sh`.

# Requirements #
Some aliases and settings make use of custom tools like `rg` (ripgrep) and `fd` (find).
To use the installer script, `stow` is required.

# Portability #
There is explicitly **no** focus on POSIX compliance or platform-independence. The configuration has only been tested on Ubuntu 16.04 systems and above.

