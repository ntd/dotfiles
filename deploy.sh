#!/bin/sh

# Link dotfiles castle
"$HOME"/.homesick/repos/homeshick/bin/homeshick -f link dotfiles

# Set custom gsettings, if dconf and the specific program is installed
dconf="$(command -v dconf)"
if test -x "$dconf"; then
    for dump in "$HOME"/.homesick/repos/dotfiles/home/.config/dconf/*.dump; do
        path=$(sed -E 's|^.*/(.*).dump$|/\1/|; s|\.|/|g' <<< "$dump")
        if test -n "$("$dconf" list $path)"; then
            "$dconf" load $path < $dump
        fi
    done
fi

# Resource the new .bashrc
source $HOME/.bashrc
