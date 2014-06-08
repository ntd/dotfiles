" Vim filetype plugin
" Language:     C
" Maintainer:   Nicola Fontana <ntd at entidi.it>
" Last Change:  24 May 2012
" Version:      1.1

if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

let c_syntax_for_h=1
let c_no_comment_fold=1

set formatoptions+=colr
set list
set listchars=tab:↔­,trail:·,precedes:⇐,extends:⇒
set foldmethod=syntax
set foldnestmax=1
set comments=sr:/*,mb:*,ex:*/,://

nmap <silent> l :if foldclosed(".")>0\|exe "normal! za"\|else\|exe "normal! l"\|endif<CR>

if has("cscope")
  set cspc=2
  nmap <Space>j :scs find g <C-R>=expand("<cword>")<CR><CR>
  nmap <Space>k :scs find s <C-R>=expand("<cword>")<CR><CR>
  nmap <Space>l :scs find d <C-R>=expand("<cword>")<CR><CR>
  nmap <Space>h :scs find c <C-R>=expand("<cword>")<CR><CR>

  au BufEnter */cpml-*	cscope add /home/nicola/sandbox/cscopes/cpml.cscope
  au BufEnter */adg-*	cscope add /home/nicola/sandbox/cscopes/adg.cscope
endif
