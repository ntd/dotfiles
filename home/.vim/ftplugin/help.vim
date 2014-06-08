" Vim filetype plugin
" Language:     Help Files
" Maintainer:   Nicola Fontana <ntd@users.sourceforge.net>
" Last Change:  11 Apr 2006
" Version:      1.0

map <buffer> <Tab>   :silent call search ("\|.*\|")<CR>
map <buffer> <S-Tab> :silent call search ("\|.*\|",'b')<CR>
map <buffer> <CR>    <C-]>
