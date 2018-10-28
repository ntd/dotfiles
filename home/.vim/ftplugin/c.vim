" Vim filetype plugin
" Language:     C
" Maintainer:   Nicola Fontana <ntd at entidi.it>
" Last Change:  27 November 2016
" Version:      1.2

let c_syntax_for_h=1
let c_no_comment_fold=1

setlocal formatoptions+=colr
setlocal listchars=tab:↔­,trail:·,precedes:⇐,extends:⇒
setlocal foldmethod=syntax
setlocal shiftwidth=4
setlocal comments=sr:/*,mb:*,ex:*/,://

nmap <silent> l :if foldclosed(".")>0\|exe "normal! za"\|else\|exe "normal! l"\|endif<CR>

if has("cscope")
  nmap <Space>j :scs find g <C-R>=expand("<cword>")<CR><CR>
  nmap <Space>k :scs find s <C-R>=expand("<cword>")<CR><CR>
  nmap <Space>l :scs find d <C-R>=expand("<cword>")<CR><CR>
  nmap <Space>h :scs find c <C-R>=expand("<cword>")<CR><CR>

  setlocal cscopepathcomp=2
  setlocal nocscopeverbose
  au BufEnter */cpml-*	cscope add /home/nicola/sandbox/cscopes/cpml.cscope
  au BufEnter */adg-*	cscope add /home/nicola/sandbox/cscopes/adg.cscope
endif
