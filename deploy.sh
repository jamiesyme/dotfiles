#!/bin/bash

# Create directory structure
mkdir -p ~/.cache \
         ~/.config \
         ~/.local/share \
         ~/bin

# Copy config
cp -R config/* ~/.config/
ln -sf $(realpath ~/.config/bash/bashrc) ~/.bashrc
ln -sf $(realpath ~/.config/bash/bash_profile) ~/.bash_profile

# Copy bins and scripts
cp maudio/maudio ~/bin/
cp minfo/minfo* ~/bin/
cp scripts/* ~/bin/
