# Sourced by any login shell, i.e. usually called by
# the display manager after logging in

# Show all GLib log messages for debugging purpose
export G_MESSAGES_DEBUG=all

# Enable proper Qt5 style if possible
if [ -x "/usr/bin/qt5ct" ]; then
    export QT_QPA_PLATFORMTHEME=qt5ct
else
    export QT_QPA_PLATFORMTHEME=gtk2
fi

# Workaround for https://bugzilla.redhat.com/show_bug.cgi?id=1056820
export NO_AT_BRIDGE=1

# Set compiler flags, if not previously set
[ -z "$CFLAGS" ]     && export CFLAGS="-O2 -Wall"
[ -z "$CXXFLAGS" ]   && export CXXFLAGS="$CFLAGS"

# Set some external helper programs
[ -z "$PAGER" ]      && export PAGER=$(command -v 2>/dev/null vimpager)
[ -z "$EDITOR" ]     && export EDITOR=$(command -v 2>/dev/null vim)

# By default I use two Wine directories instead of $HOME/.wine:
# $HOME/.win32 (32 bit) and $HOME/.win64 (64 bit, seldomly used).
# This falls back on using the 32 bit version.
[ -z "$WINEARCH" ]   && export WINEARCH=win32
[ -z "$WINEPREFIX" ] && export WINEPREFIX=$HOME/.win32

# Add a path ($2) to a variable ($1) with a `:' separated list of paths
_add_path () {
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
_add_path PATH            /usr/local/bin
_add_path LD_LIBRARY_PATH /usr/local/lib
_add_path PKG_CONFIG_PATH /usr/local/lib/pkgconfig
_add_path GI_TYPELIB_PATH /usr/local/lib/girepository-1.0
_add_path MOZ_PLUGIN_PATH /usr/local/lib/mozilla/plugins
_add_path XDG_DATA_DIRS   /usr/local/share

# Add $HOME/bin to path
_add_path PATH $HOME/bin

# Source local customizations here, if present, so
# they can override any previous setting
[ -r "$HOME/.profile-private" ] && source "$HOME/.profile-private"
