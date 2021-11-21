#!/bin/sh

echo Link dotfiles castle
"$HOME"/.homesick/repos/homeshick/bin/homeshick -f link dotfiles

echo Set custom gsettings, if dconf and the specific program is installed
dconf="$(command -v dconf)"
if test -x "$dconf"; then
    for dump in "$HOME"/.homesick/repos/dotfiles/home/.config/dconf/*.dump; do
        path=$(echo "$dump" | sed -E 's|^.*/(.*).dump$|/\1/|; s|\.|/|g')
        if test -n "$("$dconf" list $path)"; then
            "$dconf" load $path < $dump
        fi
    done
fi

echo Sourcing the new initialization script
if test "$SHELL" = "/bin/bash"; then
    source $HOME/.bashrc
elif test "$SHELL" = "/bin/csh"; then
    exec $HOME/.cshrc
fi
