" Vim filetype plugin
" Language:     remoshell script
" Maintainer:   Nicola Fontana <ntd at entidi.it>
" Last Change:  18 Oct 2011
" Version:      1.0


runtime! syntax/lua.vim

syn match Special "^[^[:space:]].*" contains=NONE
syn keyword Identifier remocommand remoresponse remoerror

let b:current_syntax = "remoshell"
