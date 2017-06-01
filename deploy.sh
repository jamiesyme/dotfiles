#!/bin/bash

# Define locations
BIN_HOME="$HOME/.local/bin"
XDG_CACHE_HOME="$HOME/.cache"
XDG_CONFIG_HOME="$HOME/.config"
XDG_DATA_HOME="$HOME/.local/share"

# Create directories
mkdir -p \
      "$BIN_HOME" \
      "$XDG_CACHE_HOME" \
      "$XDG_CONFIG_HOME" \
      "$XDG_DATA_HOME"

# Copy config
cp -R config/* "$XDG_CONFIG_HOME"
ln -sf "$XDG_CONFIG_HOME/bash/bashrc" "$HOME/.bashrc"
ln -sf "$XDG_CONFIG_HOME/bash/bash_profile" "$HOME/.bash_profile"
ln -sf "$XDG_CONFIG_HOME/emacs.d" "$HOME/.emacs.d"

# Copy bins and scripts
cp lattice/lattice* $BIN_HOME
cp maudio/maudio $BIN_HOME
cp scripts/* $BIN_HOME
