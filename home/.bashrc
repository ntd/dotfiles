# Sourced only by non-login bash, i.e. called
# for every interactive bash opened

# ls compatibility: BSD uses -G, GNU uses --color
if ls --color >/dev/null 2>&1; then
    alias ll='ls -hl --color'
else
    alias ll='ls -GhlF'
fi

# Homeshick scripts
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
source "$HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash"

# Source local customizations here, if present, so
# they can override any previous setting
[ -r "$HOME/.bashrc-private" ] && source "$HOME/.bashrc-private"
