My personal configuration files for different distro. My main desktop is
Archlinux although I use XUbuntu on my notebook and Debian or CentOS for
servers. I also have some old Ubuntu hanging around.

The files are maintained under a git repository handled by
[homeshick](https://github.com/andsens/homeshick). To deploy:

    git clone git://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
    $HOME/.homesick/repos/homeshick/bin/homeshick -b clone ntd/dotfiles
    $HOME/.homesick/repos/homeshick/bin/homeshick -f link
    source $HOME/.bashrc
