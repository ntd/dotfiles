" This is picked up by nvim < 0.5.0: newest ones use init.lua
"
" An error will be raised on neovim >= 0.5.0 because of the presence
" of Lua and vim inits (E5422), but it is basically armless.

" Disable nvim-lspconfig, that requires neovim >= 0.5.0
let g:lspconfig = 1

runtime vimrc
