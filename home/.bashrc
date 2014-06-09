alias ll='ls -hl --color'

export CFLAGS="-O2 -Wall"
export CXXFLAGS="$CFLAGS"

[ -x $(which vimpager) ] && export PAGER=vimpager
[ -x $(which vim) ] && export EDITOR=vim
[ -x $(which lua) ] && export LUA=lua

# By default I use two Wine directories instead of $HOME/.wine:
# $HOME/.win32 (32 bit) and $HOME/.win64 (64 bit, seldomly used).
# This falls back on using the 32 bit version.
export WINEARCH=win32
export WINEPREFIX=$HOME/.win32

# Add a path ($2) to a variable ($1) with a `:' separated list of paths
add_path() {
    local var=$1
    local path=$2
    local paths=${!1}

    if [ -z "$paths" ]; then
	# var is empty
	eval "$var=$path"
    elif [[ "$paths" = *$path* ]]; then
	# path is already present in var
	:
    else
	# Check for the unlocal version of path (i.e. without
	# the /local component) to prepend it at the right place
	local unlocal=${path/\/local/}
	if [[ "$paths" = *$unlocal* ]]; then
	    eval "$var=${paths/$unlocal/$path:$unlocal}"
	else
	    eval "$var=$path:$paths"
	fi
    fi

    export $var
}

# Not all distros give precedence to /usr/local
add_path PATH            /usr/local/bin
add_path LD_LIBRARY_PATH /usr/local/lib
add_path PKG_CONFIG_PATH /usr/local/lib/pkgconfig
add_path GI_TYPELIB_PATH /usr/local/lib/girepository-1.0
add_path MOZ_PLUGIN_PATH /usr/local/lib/mozilla/plugins
add_path XDG_DATA_DIRS   /usr/local/share

# Add $HOME/bin to path if $HOME is defined
[ -n "$HOME" ] && add_path PATH $HOME/bin

# Show all GLib log messages for debugging purpose
export G_MESSAGES_DEBUG=all

source "$HOME/.homesick/repos/homeshick/homeshick.sh"
source "$HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash"

# Source local customizations here, if present, so
# they can override any previous setting.
[ -r "$HOME/.bashrc-private" ] && source "$HOME/.bashrc-private"
