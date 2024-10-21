-- NeoVIM >= 0.5.0 specific features

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

-- Split handling
vim.o.splitbelow = true
vim.o.splitright = true
map('n', '_', '<cmd>split<CR>')
map('n', '|', '<cmd>vsplit<CR>')
map('n', 'X', '<cmd>quit<CR>')

-- Remap exit shortcuts for terminal buffer
map('t', '<c-w>h', '<c-\\><c-n><c-w>h')
map('t', '<c-w>l', '<c-\\><c-n><c-w>l')
map('t', '<c-w>k', '<c-\\><c-n><c-w>k')
map('t', '<c-w>j', '<c-\\><c-n><c-w>j')
map('t', '<c-w>w', '<c-\\><c-n>')
-- Use ESC for leaving insert mode in terminal buffer
map('t', '<Esc>', '<C-\\><C-n>')

-- Chain up old vim customizations
vim.cmd 'runtime vimrc'

-- Remap <Tab> <S-Tab> to provide better completion experience
do
    local function space_before()
        local col = vim.fn.col('.') - 1
        return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
    end
    local function t(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
    end
    function CompletionTab()
        local remap = vim.fn.pumvisible() == 1 or not space_before()
        return t(remap and '<C-n>' or '<Tab>')
    end
    function CompletionSTab()
        local remap = vim.fn.pumvisible() == 1
        return t(remap and '<C-p>' or '<S-Tab>')
    end
    map('si', '<Tab>',   'v:lua.CompletionTab()',  { expr = true })
    map('si', '<S-Tab>', 'v:lua.CompletionSTab()', { expr = true })
end

require('gitsigns').setup {
    on_attach = function (bufnr)
        local gitsigns = require('gitsigns')

        local function luamap(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        luamap('n', 'gk', function () gitsigns.nav_hunk('prev') end)
        luamap('n', 'gj', function () gitsigns.nav_hunk('next') end)
        luamap('n', 'gv', gitsigns.select_hunk)
        luamap('n', 'gl', gitsigns.stage_hunk)
        luamap('n', 'gh', gitsigns.reset_hunk)
        luamap('n', 'gK', gitsigns.preview_hunk)
    end,
}

require('lualine').setup {
    options = {
        icons_enabled = false,
        theme = 'horizon',
    },
}

local function lsp_buffer_customization(client, buffer)
    local function luamap(kbd, lua)
        local function mapper(mode, mkbd, cmd, opts)
            return vim.api.nvim_buf_set_keymap(buffer, mode, mkbd, cmd, opts)
        end
        map('n', kbd, '<cmd>lua ' .. lua .. '<CR>', nil, mapper)
    end
    luamap('gD', 'vim.lsp.buf.declaration()')
    luamap('gd', 'vim.lsp.buf.definition()')
    luamap('gs', 'vim.lsp.buf.references()')
    luamap('gr', 'vim.lsp.buf.rename()')
    luamap('gi', 'vim.lsp.buf.implementation()')
    luamap('gt', 'vim.lsp.buf.type_definition()')
    luamap('gp', 'vim.diagnostic.goto_prev()')
    luamap('gn', 'vim.diagnostic.goto_next()')
    luamap('K',  'vim.lsp.buf.hover()')
end

require('lspconfig').clangd.setup {
    on_attach = lsp_buffer_customization,
}

-- Disabling PHP support for now (psalm) because it seems to be
-- a lot of troubles for little gain.

require('lspconfig').lua_ls.setup {
    on_attach = lsp_buffer_customization,
}

require('lspconfig').zls.setup {
    on_attach = lsp_buffer_customization,
}

-- Without this line the language servers must be started manually with
-- `:LspStart` even with the autostart flag on:
vim.api.nvim_exec_autocmds('FileType', {})
