umask 22

alias ll ls -GhlF

set path = (/sbin /bin /usr/sbin /usr/bin /usr/games /usr/local/sbin /usr/local/bin $HOME/bin)

setenv LANG		en_US.UTF-8
setenv MM_CHARSET	UTF-8

setenv CFLAGS		"-O2 -Wall"
setenv CXXFLAGS		"$CFLAGS"

setenv EDITOR		vim
setenv PAGER		vimpager
setenv BLOCKSIZE	K

# Show all GLib log messages for debugging purpose
setenv G_MESSAGES_DEBUG	all

if ($?prompt) then
	# An interactive shell -- set some stuff up
	set prompt = "%N@%m:%~ %# "
	set promptchars = "%#"

	set filec
	set history = 1000
	set savehist = (1000 merge)
	set autolist = ambiguous
	# Use history to aid expansion
	set autoexpand
	set autorehash
	set mail = (/var/mail/$USER)

	bindkey "\e[1;5D" backward-word
	bindkey "\e[1;5C" forward-word
	bindkey "^R" i-search-back

	if ( $?tcsh ) then
		bindkey "^W" backward-delete-word
		bindkey -k up history-search-backward
		bindkey -k down history-search-forward
	endif
endif

# Homeshick for C shell
alias homeshick "source $HOME/.homesick/repos/homeshick/bin/homeshick.csh"
