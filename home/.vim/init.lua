-- NeoVIM specific features
local function tnoremap(from, to)
    vim.api.nvim_set_keymap('t', from, to, { noremap = true })
end

-- Remap exit shortcuts for terminal buffer
tnoremap('<c-w>h', '<c-\\><c-n><c-w>h')
tnoremap('<c-w>l', '<c-\\><c-n><c-w>l')
tnoremap('<c-w>k', '<c-\\><c-n><c-w>k')
tnoremap('<c-w>j', '<c-\\><c-n><c-w>j')
tnoremap('<c-w>w', '<c-\\><c-n>')

-- Use ESC for leaving insert mode in terminal buffer
tnoremap('<Esc>', '<C-\\><C-n>')

vim.cmd [[
    au TermOpen * setlocal norelativenumber
    let g:loaded_lightline = 1
    runtime vimrc
]]

require('gitsigns').setup {
    keymaps = {
        ['n dn'] = { expr = true, "&diff ? ']c' : '<cmd>lua require \"gitsigns.actions\".next_hunk()<CR>'" },
        ['n dp'] = { expr = true, "&diff ? '[c' : '<cmd>lua require \"gitsigns.actions\".prev_hunk()<CR>'" },
    },
}

require('lualine').setup {
    options = {
        icons_enabled = false,
        theme = 'horizon',
    },
}
