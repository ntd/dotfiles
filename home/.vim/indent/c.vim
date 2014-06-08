" K&R indentation style
" Language:     C and derived
" Maintainer:   Nicola Fontana <ntd at entidi.it>
" Last Change:  29 June 2008
" Version:      1.0
"

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal textwidth=78
setlocal cindent
setlocal nosmartindent
setlocal shiftwidth=4
setlocal tabstop=8
setlocal softtabstop=4
setlocal expandtab
setlocal cinoptions=p0,t0,+4,(0,u4,U1,:0
