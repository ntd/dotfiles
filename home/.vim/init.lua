-- NeoVIM >= 0.5.0 specific features

local function map(modestring, kbd, cmd, opts)
    local modes = {}
    for mode in modestring:gmatch('.') do table.insert(modes, mode) end
    opts = opts or {}
    opts.silent = opts.silent or true
    vim.keymap.set(modes, kbd, cmd, opts)
end

-- Disable unused providers
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0

-- Quickly switch this buffer to a terminal
map('nvo', 'tt', '<cmd>terminal<CR>')
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
    map('si', '<Tab>', function()
        local remap = vim.fn.pumvisible() == 1 or not space_before()
        return t(remap and '<C-n>' or '<Tab>')
    end, { expr = true })
    map('si', '<S-Tab>', function()
        local remap = vim.fn.pumvisible() == 1
        return t(remap and '<C-p>' or '<S-Tab>')
    end, { expr = true })
end

if vim.fn.has('nvim-0.8') == 1 then
    -- GitSigns does not have proper neovim version check
    vim.cmd 'packadd gitsigns.nvim'
    require('gitsigns').setup {
        on_attach = function (buffer)
            local gitsigns = require('gitsigns')
            local opts = { buffer = buffer }
            map('n', 'gk', function () gitsigns.nav_hunk('prev') end, opts)
            map('n', 'gj', function () gitsigns.nav_hunk('next') end, opts)
            map('n', 'gv', gitsigns.select_hunk, opts)
            map('n', 'gl', gitsigns.stage_hunk, opts)
            map('n', 'gh', gitsigns.reset_hunk, opts)
            map('n', 'gK', gitsigns.preview_hunk, opts)
        end,
    }
end

vim.cmd 'packadd lualine.nvim'
require('lualine').setup {
    options = {
        icons_enabled = false,
        theme = 'horizon',
    },
}

if vim.fn.has('nvim-0.8') == 1 then
    local function lsp_buffer_customization(_, buffer)
        local opts = { buffer = buffer }
        map('n', 'gD', vim.lsp.buf.declaration, opts)
        map('n', 'gd', vim.lsp.buf.definition, opts)
        map('n', 'gs', vim.lsp.buf.references, opts)
        map('n', 'gr', vim.lsp.buf.rename, opts)
        map('n', 'gi', vim.lsp.buf.implementation, opts)
        map('n', 'gt', vim.lsp.buf.type_definition, opts)
        map('n', 'gp', vim.diagnostic.goto_prev, opts)
        map('n', 'gn', vim.diagnostic.goto_next, opts)
        map('n', 'K',  vim.lsp.buf.hover, opts)
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
elseif not vim.notify_once then
    -- Silent warning message because of missing function:
    -- I *know* lsp is not properly supported on old NeoVIM, thank you!
    vim.notify_once = function () end
end

-- Basic half-working termdebug support
-- XXX: these bindings should be enabled only inside a Termdebug buffer
vim.cmd 'packadd termdebug'
map('nvo', 'dbk',  '<cmd>Evaluate<CR>')
map('nvo', 'dbc',  '<cmd>Continue<CR>')
map('nvo', 'dbb',  '<cmd>Break<CR>')
map('nvo', 'dbj', '<cmd>Over<CR>')
map('nvo', 'dbl', '<cmd>Step<CR>')
map('nvo', 'dbr',  '<cmd>Run<CR>')
map('nvo', 'dbf',  '<cmd>Finish<CR>')
map('nvo', 'dbu',  '<cmd>Until<CR>')
map('nvo', 'dbx',  '<cmd>Stop<CR>')
vim.g.termdebug_config = {
    wide = 1,
    map_K = 0,
    sign = '+',
    variables_window = 1,
    variables_window_height = 10,
}
