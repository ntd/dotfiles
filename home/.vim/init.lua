-- NeoVIM specific features
local function map(mode, kbd, cmd, opts)
    if not opts then
        opts = {
            noremap = true,
            silent = true,
        }
    end
    vim.api.nvim_set_keymap(mode, kbd, cmd, opts)
end

-- Remap exit shortcuts for terminal buffer
map('t', '<c-w>h', '<c-\\><c-n><c-w>h')
map('t', '<c-w>l', '<c-\\><c-n><c-w>l')
map('t', '<c-w>k', '<c-\\><c-n><c-w>k')
map('t', '<c-w>j', '<c-\\><c-n><c-w>j')
map('t', '<c-w>w', '<c-\\><c-n>')
-- Use ESC for leaving insert mode in terminal buffer
map('t', '<Esc>', '<C-\\><C-n>')

vim.cmd [[
    au TermOpen * setlocal norelativenumber
    " Use lualine instead of lightline.vim
    let g:loaded_lightline = 1
    " Use nvim-lspconfig instead of vim-lsp
    let g:lsp_loaded = 1
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

local function lsp_buffer_customization(client, buffer)
    local function map_lua(kbd, lua, opts)
        local cmd = '<cmd>lua ' .. lua .. '<CR>'
        if not opts then
            opts = {
                noremap = true,
                silent = true,
            }
        end
        vim.api.nvim_buf_set_keymap(buffer, 'n', kbd, cmd, opts)
    end
    map_lua('gd',         'vim.lsp.buf.definition()')
    map_lua('gs',         'vim.lsp.buf.incoming_calls()')
    map_lua('gr',         'vim.lsp.buf.references()')
    map_lua('gi',         'vim.lsp.buf.implementation()')
    map_lua('gt',         'vim.lsp.buf.type_definition()')
    map_lua('<leader>rn', 'vim.lsp.buf.rename()')
    map_lua('gp',         'vim.lsp.diagnostic.goto_prev()')
    map_lua('gn',         'vim.lsp.diagnostic.goto_next()')
    map_lua('K',          'vim.lsp.buf.hover()')
end
require('lspconfig').clangd.setup {
    on_attach = lsp_buffer_customization,
}
