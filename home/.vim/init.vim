" NeoVIM specific features

" Remap exit shortcuts for terminal buffer
tnoremap <c-w>h <c-\><c-n><c-w>h
tnoremap <c-w>l <c-\><c-n><c-w>l
tnoremap <c-w>k <c-\><c-n><c-w>k
tnoremap <c-w>j <c-\><c-n><c-w>j
tnoremap <c-w>w <c-\><c-n>

" Use ESC for leaving insert mode in terminal buffer
:tnoremap <Esc> <C-\><C-n>

au TermOpen * setlocal norelativenumber

runtime vimrc
