# Sourced by any login shell, i.e. usually called by
# the display manager after logging in

# Source the user provided locale.conf, if present
[ -r "$HOME/.config/locale.conf" ] && source "$HOME/.config/locale.conf"

# Workaround for https://bugzilla.redhat.com/show_bug.cgi?id=1056820
export NO_AT_BRIDGE=1

# Set compiler flags, if not previously set
[ -z "$CFLAGS" ]   && export CFLAGS="-O2 -Wall"
[ -z "$CXXFLAGS" ] && export CXXFLAGS="$CFLAGS"

# Set the default editor
if command -v nvim &> /dev/null; then
    export EDITOR=$(command -v nvim)
elif command -v vim &> /dev/null; then
    export EDITOR=$(command -v vim)
fi

# Set nvimpager/vimpager as default pager, if found
if test -z "$PAGER"; then
    if command -v nvimpager &> /dev/null; then
	export PAGER=$(command -v nvimpager)
    elif command -v vimpager &> /dev/null; then
	export PAGER=$(command -v vimpager)
    fi
fi

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

# Add local paths
_add_path PATH $HOME/bin
_add_path PATH $HOME/.local/bin

# Include luarocks path, if relevant
[ -d "$HOME/.luarocks/bin" ] && _add_path PATH $HOME/.luarocks/bin

# OpenResty customizations
[ -d "/opt/openresty" ] && _add_path PATH /opt/openresty/bin:/opt/openresty/nginx/sbin

# Required by pinentry programs
export GPG_TTY=$(/usr/bin/tty)

# Chain up `.bashrc`, if relevant
[ -n "$BASH_VERSION" ] && source "$HOME/.bashrc"

# Source local customizations here, if presents,
# so they can override any previous setting
[ -r "$HOME/.profile-private" ] && source "$HOME/.profile-private"

:
