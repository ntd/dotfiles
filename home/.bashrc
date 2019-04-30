# Sourced only by non-login bash, i.e. called
# for every interactive bash opened

# ls compatibility: BSD uses -G, GNU uses --color
if ls --color >/dev/null 2>&1; then
    alias ll='ls -hl --color'
else
    alias ll='ls -GhlF'
fi

# Multitail shortcuts
alias mt='multitail --config ~/.config/multitail.conf --basename'
ssmt () {
    mt	-CS ss -s 2 -P l \
	/var/log/silverstripe/$1.log \
	/var/log/nginx/error.$1.log
}

# Redis shortcut
alias redis-cli='/usr/bin/redis-cli -s /run/redis/redis.sock'

# Homeshick scripts
if [ -e "$HOME/.homesick/repos/homeshick/homeshick.sh" ]; then
    source "$HOME/.homesick/repos/homeshick/homeshick.sh"
    source "$HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash"
fi

# OpenResty customizations
if [ -d "/opt/openresty" ]; then
    PATH=$PATH:/opt/openresty/bin:/opt/openresty/nginx/sbin
fi

# Include luarocks binary in search path
if [ -d "$HOME/.luarocks/bin" ]; then
    PATH=$HOME/.luarocks/bin:$PATH
fi

export PATH

_prefix_lua_path () {
    local lua=$1
    local var=$2

    # Remove duplicates and prepend every item
    # with its /usr/local/ version (if relevant)
    $lua -e "local k, v = {}, {}
	     for p in $var:gmatch('[^;]+') do
		 local s = (p:gsub('/usr/local/', '/usr/'))
		 local h = (s:gsub('/usr/', '$HOME/.luarocks/'))
		 local l = (s:gsub('/usr/', '/usr/local/'))
		 if not k[h] then k[h] = true v[#v+1] = h end
		 if not k[l] then k[l] = true v[#v+1] = l end
		 if not k[s] then k[s] = true v[#v+1] = s end
	     end print(table.concat(v, ';'))"
}

# The following function is intended to be used interactively when you
# want to change the Lua version currently active, e.g.:
#
#     $ switch_to_lua lua5.1
#     $ echo $LUA_CPATH
#     ./?.so;/usr/local/lib/lua/5.1/?.so;/usr/lib/lua/5.1/?.so;...
#     $ switch_to_lua lua5.2
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

# Enable the configuration for the default Lua
switch_to_lua lua

# Required by pinentry programs
export GPG_TTY=$(/usr/bin/tty)

# Source local customizations here, if present, so
# they can override any previous setting
[ -r "$HOME/.bashrc-private" ] && source "$HOME/.bashrc-private"
