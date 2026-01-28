# Sourced only by non-login bash, i.e. called
# for every interactive bash opened

# Ghostty integration
if [ -n "$GHOSTTY_RESOURCES_DIR" ]; then
    source "$GHOSTTY_RESOURCES_DIR/shell-integration/bash/ghostty.bash"
fi

# ls compatibility: BSD uses -G, GNU uses --color
if ls --color >/dev/null 2> /dev/null; then
    alias ll='ls -hl --color'
else
    alias ll='ls -GhlF'
fi

# Set NeoVIM related shortcuts if stock VIM is not present
if test -z "$(command -v vim)"; then
    cmd="$(command -v nvim)"
    if test -n "$cmd"; then
	alias vim="$cmd"
	alias vimdiff="$cmd -d"
    fi
fi

# Dumb workaround to make aliases work with `sudo`:
# https://wiki.archlinux.org/title/Sudo#Passing_aliases
cmd="$(command -v sudo)"
if test -n "$cmd"; then
    alias sudo="$cmd "
fi

# I always keep forgetting how to force password authentication in SSH
cmd="$(command -v ssh)"
if test -n "$cmd"; then
    alias sshp="$cmd -o PreferredAuthentications=password -o PubkeyAuthentication=no"
fi

# Avoid duplicates in .bash_history
export HISTCONTROL=ignoreboth:erasedups

# Taskwarrior interface
cmd="$(command -v taskwarrior-tui)"
if test -n "$cmd"; then
    alias vit="$cmd"
fi

# Source VTE specific script, if found
if test -r /etc/profile.d/vte.sh; then
    source /etc/profile.d/vte.sh
fi

# Custom select graphic rendition on a specific string
_SGR () {
    printf "\033[%dm%s\033[0m" "$1" "$2"
}
_ps1_status () {
    local rv=$?
    local color
    local symbol
    if [ $rv = 0 ]; then
	color=32
	symbol='✓'
    else
	color=31
	symbol='✗'
    fi
    _SGR $color $symbol
    return $rv
}
_ps1_branch () {
    local branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
    local color
    local sync
    if [ $branch ]; then
	git diff --quiet 2> /dev/null && color="32" || color="31"
	test -z "$(git cherry 2> /dev/null)" && sync='' || sync='*'
	_SGR $color "$branch$sync "
    fi
}
# Enhancements over stock bash prompt:
# - a green check or a red cross suggests the last exit code
# - the current time is always shown, for quick and dirty profiling
# - the current branch of the git repository (if any) is shown
# - the git branch is green if clean or red if dirty
# - an asterisk after the branch highlights there is a pending push
PS1='$(_ps1_status) \t $(_ps1_branch)\u@\h \W \$ '

# Multitail shortcuts
cmd="$(command -v multitail)"
if test -n "$cmd"; then
    alias mt='multitail --config ~/.config/multitail.conf --basename'
    ssmt () {
	mt	-s 2\
	    /var/log/silverstripe/$1.log \
	    /var/log/nginx/error.$1.log
	}
fi

# Redis shortcut
cmd="$(command -v redis-cli)"
if test -n "$cmd"; then
    alias redis-cli="$cmd -s /run/redis/redis.sock"
fi

# Homeshick scripts
if [ -e "$HOME/.homesick/repos/homeshick/homeshick.sh" ]; then
    source "$HOME/.homesick/repos/homeshick/homeshick.sh"
    source "$HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash"
fi

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
    [ -x "$lua" ] || lua=$(command -v $lua 2> /dev/null)
    [ -x "$lua" ] || return 1

    # Redefine the relevant environmental variables
    export LUA="$lua"
    export LUA_PATH=$(_prefix_lua_path $lua package.path)
    export LUA_CPATH=$(_prefix_lua_path $lua package.cpath)
}

# Enable the configuration for the default Lua command
if command -v lua &> /dev/null; then
    switch_to_lua lua
fi

# Source local customizations here, if presents,
# so they can override any previous setting
[ -r "$HOME/.bashrc-private" ] && source "$HOME/.bashrc-private"

:
