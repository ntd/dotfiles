if ls --color >/dev/null 2>&1; then
    alias ll='ls -hl --color'
else
    alias ll='ls -GhlF'
fi

# Set some environmental variables with fallback values. They must be
# set only if not previously set.
[ -z "$CFLAGS" ]     && export CFLAGS="-O2 -Wall"
[ -z "$CXXFLAGS" ]   && export CXXFLAGS="$CFLAGS"
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

_prefix_lua_path () {
    local lua=$1
    local var=$2

    # Remove duplicates and prepend every item
    # with its /usr/local/ version (if relevant)
    $lua -e "local k, v = {}, {}
	     for p in $var:gmatch('[^;]+') do
		 local l = (p:gsub('/usr/local/', '/usr/'):gsub('/usr/', '/usr/local/'))
		 if not k[l] then k[l] = true v[#v+1] = l end
		 if not k[p] then k[p] = true v[#v+1] = p end
	     end print(table.concat(v, ';'))"
}

# The following function is intended to be used also interactively
# when you want to change the Lua version currently active, e.g.:
#
#     $ switch_to_lua lua5.1
#     $ echo $LUA_CPATH
#     ./?.so;/usr/local/lib/lua/5.1/?.so;/usr/lib/lua/5.1/?.so;...
#     $ switch_to_lua lua
#     $ echo $LUA_CPATH
#     /usr/local/lib/lua/5.2/?.so;/usr/lib/lua/5.2/?.so;...
#
switch_to_lua () {
    local lua=$1

    # Unset the Lua environment here, so if the Lua binary is not found
    # the variables are left unset
    unset LUA LUA_PATH LUA_CPATH

    # Use the absolute path to the binary, if not specified
    [ -x "$lua" ] || lua=$(command -v 2>/dev/null $lua)
    [ -x "$lua" ] || return 1

    # Redefine the relevant environmental variables
    export LUA="$lua"
    export LUA_PATH=$(_prefix_lua_path $lua package.path)
    export LUA_CPATH=$(_prefix_lua_path $lua package.cpath)
}


# Not all distros give precedence to /usr/local
_add_path PATH            /usr/local/bin
_add_path LD_LIBRARY_PATH /usr/local/lib
_add_path PKG_CONFIG_PATH /usr/local/lib/pkgconfig
_add_path GI_TYPELIB_PATH /usr/local/lib/girepository-1.0
_add_path MOZ_PLUGIN_PATH /usr/local/lib/mozilla/plugins
_add_path XDG_DATA_DIRS   /usr/local/share

# Enable the default lua binary, prepending /usr/local/ to its paths
switch_to_lua lua

# Add $HOME/bin to path
_add_path PATH $HOME/bin

# Show all GLib log messages for debugging purpose
export G_MESSAGES_DEBUG=all

source "$HOME/.homesick/repos/homeshick/homeshick.sh"
source "$HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash"

# Source local customizations here, if present, so
# they can override any previous setting.
[ -r "$HOME/.bashrc-private" ] && source "$HOME/.bashrc-private"
