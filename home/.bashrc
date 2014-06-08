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

# Not all distros give precedence to /usr/local
export PATH=${PATH/\/usr\/bin/\/usr\/local\/bin:\/usr\/bin}
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
export GI_TYPELIB_PATH=/usr/local/lib/girepository-1.0:$GI_TYPELIB_PATH

# Show all GLib log messages for debugging purpose
export G_MESSAGES_DEBUG=all

source "$HOME/.homesick/repos/homeshick/homeshick.sh"
source "$HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash"

# Source local customizations here, if present, so
# they can override any previous setting.
[ -r "$HOME/.bashrc-private" ] && source "$HOME/.bashrc-private"
