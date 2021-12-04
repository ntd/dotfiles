-- NeoVIM specific features

-- Helper map function
-- Provide more sensible defaults and support multimodes setup.
local function map(modes, kbd, cmd, opts, mapper)
    opts = opts or {}
    opts.silent = opts.silent or true
    opts.noremap = opts.noremap or true
    mapper = mapper or vim.api.nvim_set_keymap
    for mode in modes:gmatch('.') do
        mapper(mode, kbd, cmd, opts)
    end
end

-- Remap exit shortcuts for terminal buffer
map('t', '<c-w>h', '<c-\\><c-n><c-w>h')
map('t', '<c-w>l', '<c-\\><c-n><c-w>l')
map('t', '<c-w>k', '<c-\\><c-n><c-w>k')
map('t', '<c-w>j', '<c-\\><c-n><c-w>j')
map('t', '<c-w>w', '<c-\\><c-n>')
-- Use ESC for leaving insert mode in terminal buffer
map('t', '<Esc>', '<C-\\><C-n>')

-- Chain up old vim customizations
vim.cmd [[
    au TermOpen * setlocal norelativenumber
    " Use lualine instead of lightline.vim
    let g:loaded_lightline = 1
    " Use nvim-lspconfig instead of vim-lsp
    let g:lsp_loaded = 1
    runtime vimrc
]]

-- Remap <Tab> <S-Tab> to provide better completion experience
do
    local function space_before()
        local col = vim.fn.col('.') - 1
        return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
    end
    local function t(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
    end
    function tab_complete()
        local remap = vim.fn.pumvisible() == 1 or not space_before()
        return t(remap and '<C-n>' or '<Tab>')
    end
    function s_tab_complete ()
        local remap = vim.fn.pumvisible() == 1
        return t(remap and '<C-p>' or '<S-Tab>')
    end
    map('si', '<Tab>',   'v:lua.tab_complete()',   { expr = true })
    map('si', '<S-Tab>', 'v:lua.s_tab_complete()', { expr = true })
end

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
    local function luamap(kbd, lua)
        local function mapper(mode, kbd, cmd, opts)
            return vim.api.nvim_buf_set_keymap(buffer, mode, kbd, cmd, opts)
        end
        map('n', kbd, '<cmd>lua ' .. lua .. '<CR>', nil, mapper)
    end
    luamap('gd', 'vim.lsp.buf.definition()')
    luamap('gs', 'vim.lsp.buf.references()')
    luamap('gr', 'vim.lsp.buf.rename()')
    luamap('gi', 'vim.lsp.buf.implementation()')
    luamap('gt', 'vim.lsp.buf.type_definition()')
    luamap('gp', 'vim.lsp.diagnostic.goto_prev()')
    luamap('gn', 'vim.lsp.diagnostic.goto_next()')
    luamap('K',  'vim.lsp.buf.hover()')
end
require('lspconfig').clangd.setup {
    on_attach = lsp_buffer_customization,
}
