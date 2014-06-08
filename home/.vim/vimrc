if &cp | set nocp | endif
let s:cpo_save=&cpo
set cpo&vim

set dir=/tmp                    " Directory for temporary files

runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()          " Enable pathogen 'package manager'

set t_ti= t_te=                 " Avoid restoring screen at end of session
set mouse=                      " Let copy&paste with mouse work on SSH

                                " Custom bindings for Vimux
map <Leader>vp :VimuxPromptCommand<CR>
map <Leader>vl :VimuxRunLastCommand<CR>
map <Leader>vi :VimuxInspectRunner<CR>
map <Leader>vx :VimuxInterruptRunner<CR>

set modeline
set notimeout                   " Don't timeout on mappings
set ttimeout                    " Do timeout on terminal key codes
set timeoutlen=100              " Timeout after 100 msec
set splitright                  " Predilige vertical split on the right
let g:proj_flags='mstvcg'       " 'Project' flags
let g:proj_file='.config/vimproject'
let g:proj_split='vs'           " Split vertically
set helplang=en

if has("gui_running") || &t_Co >= 88
    set cursorline              " Highlight the current line
endif
colorscheme wombat256
set background=dark

let &termencoding=&encoding
set encoding=utf-8

set listchars=tab:↔­,trail:·,precedes:⇐,extends:⇒
set list
set showmode
set showcmd
set showmatch
set nonumber
set ruler
set laststatus=2

set incsearch
set hlsearch
set ignorecase
set smartcase

set autoindent
set tabstop=8
set shiftwidth=4
set softtabstop=4

if version >= 730
    set colorcolumn=72
endif
set wrap
set textwidth=72
set hidden
set backspace=indent,eol,start

set nobackup
set nowritebackup

filetype plugin indent on
syntax enable

let &cpo=s:cpo_save
unlet s:cpo_save
