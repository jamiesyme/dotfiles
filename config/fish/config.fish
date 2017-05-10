
# Add color to ls
#function ls
#	ls --color=auto
#end


# Define variables
set -x XDG_DATA_HOME   ~/.local/share
set -x XDG_CONFIG_HOME ~/.config
set -x XDG_CACHE_HOME  ~/.cache

set -x __GL_SHADER_DISK_CACHE_PATH $XDG_CACHE_HOME/nv
set -x CUDA_CACHE_PATH             $XDG_CACHE_HOME/nv
set -x GNUPGHOME                   $XDG_CONFIG_HOME/gnupg
set -x GTK2_RC_FILES               $XDG_CONFIG_HOME/gtk-2.0/gtkrc
set -x LESSHISTFILE                $XDG_CACHE_HOME/less/history
set -x MPLAYER_HOME                $XDG_CONFIG_HOME/mplayer
set -x PASSWORD_STORE_DIR          $XDG_CONFIG_HOME/password-store
set -x SPACEMACSDIR                $XDG_CONFIG_HOME/spacemacs
set -x VIMINIT                     'let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'
set -x XINITRC                     $XDG_CONFIG_HOME/X11/xinitrc

set -x VISUAL vim
set -x EDITOR $VISUAL
set -x QT_STYLE_OVERRIDE gtk


# Configure path
set -x PATH $HOME/bin $HOME/.yarn/bin $PATH


# Start X at login
if status --is-login
	if test -z "$DISPLAY" -a $XDG_VTNR = 1
		exec startx $XINITRC
	end
end
