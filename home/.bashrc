# Sourced only by non-login bash, i.e. called
# for every interactive bash opened

# ls compatibility: BSD uses -G, GNU uses --color
if ls --color >/dev/null 2>&1; then
    alias ll='ls -hl --color'
else
    alias ll='ls -GhlF'
fi

# Set a decent TERM for xfce4-terminal
if [ "$COLORTERM" = "xfce4-terminal" ]; then
    export TERM=xterm-256color
fi

# Homeshick scripts
if [ -e "$HOME/.homesick/repos/homeshick/homeshick.sh" ]; then
    source "$HOME/.homesick/repos/homeshick/homeshick.sh"
    source "$HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash"
fi

# OpenResty customizations
if [ -d "/opt/openresty" ]; then
    export PATH=$PATH:/opt/openresty/bin:/opt/openresty/nginx/sbin
fi

# Source local customizations here, if present, so
# they can override any previous setting
[ -r "$HOME/.bashrc-private" ] && source "$HOME/.bashrc-private"
