#!/bin/bash

mkdir -p ~/.cache \
         ~/.config \
         ~/.local/share \
         ~/bin

cp -R config/* ~/.config/
ln -sf $(realpath ~/.config/bash/bashrc) ~/.bashrc
ln -sf $(realpath ~/.config/bash/bash_profile) ~/.bash_profile
ln -sf $(realpath scripts/init-audio.sh) ~/bin/init-audio
ln -sf $(realpath scripts/init-feh.sh) ~/bin/init-feh
ln -sf $(realpath scripts/init-xrandr.sh) ~/bin/init-xrandr
ln -sf $(realpath maudio/maudio) ~/bin/maudio
ln -sf $(realpath maudio/maudio_i3block) ~/bin/maudio_i3block
ln -sf $(realpath minfo/minfo) ~/bin/minfo
ln -sf $(realpath minfo/minfo-msg) ~/bin/minfo-msg
