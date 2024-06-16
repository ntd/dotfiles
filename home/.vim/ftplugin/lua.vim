if has('nvim')
  setlocal foldmethod=expr
  setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
else
  setlocal foldmethod=syntax
  " Disable this dumb autocompletion feature: it gets in the way everytime!
  let g:lua_complete_dynamic=0
endif
