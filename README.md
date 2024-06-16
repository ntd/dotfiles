My personal configuration files for different distros. My main desktop is
ArchLinux but I also have different Ubuntu flavours installed on notebooks
and a bunch of Debian-based distros scattered around the world.

These files are maintained under a git repository handled by
[homeshick](https://github.com/andsens/homeshick). To deploy:

    git clone https://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
    $HOME/.homesick/repos/homeshick/bin/homeshick -b clone ntd/dotfiles
    source $HOME/.homesick/repos/dotfiles/deploy.sh
