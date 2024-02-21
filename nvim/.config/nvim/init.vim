"""
" @author 
"                                     
"      _/_/_/    _/_/_/  _/      _/   
"   _/        _/          _/  _/      
"  _/  _/_/    _/_/        _/         
" _/    _/        _/      _/          
"  _/_/_/  _/_/_/        _/           
"
                                    
" General nvim settings


" Syntax settings
syntax on
filetype plugin indent on
syntax enable

" Text editing settings
set shiftwidth=4 
set expandtab 
set tabstop=4 
set softtabstop=4 
set autoindent
set number showmatch
" Hides an abandoned buffer instead of unloading it
set hidden

" Helper function for stripping trailing whitespace 
" Taken from StackOverflow
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

" Automatically trims trailing whitespace for C, C++, Python and others
autocmd FileType c,cpp,python,sh,bash,zsh,java,cl,cmake autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

" Treats .cl files as C code
" @note Project specific
autocmd BufNewFile,BufRead,BufReadPost *.cl set filetype=c

"" Clipboard settings
" Uses system clipboard
set clipboard+=unnamedplus

" Graphics / terminal fixes
set guicursor=
set shortmess=I

" Backup settings
set nobackup
set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin()
"Plug 'SirVer/ultisnips'
"Plug 'honza/vim-snippets'
"Plug 'ervandew/supertab'

" general plugins
Plug 'majutsushi/tagbar'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'bling/vim-bufferline'
Plug 'preservim/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'Xuyuanp/nerdtree-git-plugin', 
Plug 'chrisbra/Recover.vim'

" denite
Plug 'Shougo/denite.nvim', {'do': ':UpdateRemotePlugins'}

" Extended regex syntax
Plug 'othree/eregex.vim'

" Language servers
Plug 'neovim/nvim-lspconfig'

" Linters
Plug 'rhysd/vim-clang-format'

" versioning
Plug 'tpope/vim-fugitive'

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" python
Plug 'bfredl/nvim-ipy'

" rust
Plug 'simrat39/rust-tools.nvim'

"" Optional dependencies
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter' " Do :TSInstall all and :TSUpdate
"manually, afterwards
Plug 'nvim-telescope/telescope.nvim'

" wandbox
Plug 'rhysd/wandbox-vim'

" debugging
Plug 'sakhnik/nvim-gdb'

Plug 'qpkorr/vim-bufkill'

" color palette
Plug 'morhetz/gruvbox'

call plug#end()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Avoid nested instances
if has('nvim') && executable('nvr')
    let $VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
    let $GIT_EDITOR="nvr -cc split --remote-wait +'set bufhidden=wipe'"
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""" Plugin settings
"" lspconfig
lua << EOF
local lspconfig = require('lspconfig')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.server_capabilities.documentFormattingProvider then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
  end
  if client.server_capabilities.documentRangeFormattingProvider  then
    buf_set_keymap("v", "<space>f", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

lspconfig.ccls.setup {
    on_attach=on_attach,
    init_options = {
        index = {
            threads = 0;
        };
    }
}

local rust_tools_opts = {
    tools = { -- rust-tools options
        -- automatically set inlay hints (type hints)
        -- There is an issue due to which the hints are not applied on the first
        -- opened file. For now, write to the file to trigger a reapplication of
        -- the hints or just run :RustSetInlayHints.
        -- default: true
        autoSetHints = true,

        runnables = {
            -- whether to use telescope for selection menu or not
            -- default: true
            use_telescope = true

            -- rest of the opts are forwarded to telescope
        },

        inlay_hints = {
            -- wheter to show parameter hints with the inlay hints or not
            -- default: true
            show_parameter_hints = true,

            -- prefix for parameter hints
            -- default: "<-"
            parameter_hints_prefix = "<-",

            -- prefix for all the other hints (type, chaining)
            -- default: "=>"
            other_hints_prefix  = "=>",

            -- whether to align to the lenght of the longest line in the file
            max_len_align = false,

            -- padding from the left if max_len_align is true
            max_len_align_padding = 1,

            -- whether to align to the extreme right or not
            right_align = false,

            -- padding from the right if right_align is true
            right_align_padding = 7,
        },

        hover_actions = {
            -- the border that is used for the hover window
            -- see vim.api.nvim_open_win()
            border = {
              {"╭", "FloatBorder"},
              {"─", "FloatBorder"},
              {"╮", "FloatBorder"},
              {"│", "FloatBorder"},
              {"╯", "FloatBorder"},
              {"─", "FloatBorder"},
              {"╰", "FloatBorder"},
              {"│", "FloatBorder"}
            },
        }
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = { -- rust-analyer options
        on_attach=on_attach,
        cmd = {'rust-analyzer'},
        settings = {
            ["rust-analyzer"] = {
                assist = {
                    importMergeBehavior = "last",
                    importPrefix = "by_self",
                },
                cargo = {
                    loadOutDirsFromCheck = true
                },
                procMacro = {
                    enable = true
                },
            }
        }
    }
}
-- Sets up lspconfig already
local rust_tools = require('rust-tools')
rust_tools.setup(rust_tools_opts)

-- Use a loop to conveniently both setup defined servers 
-- and map buffer local keybindings when the language server attaches

--local servers = { "ccls", "rust_analyzer" }
--for _, lsp in ipairs(servers) do
--  lspconfig[lsp].setup { on_attach = on_attach }
--end

lspconfig.pyright.setup{on_attach=on_attach}
lspconfig.eslint.setup{on_attach=on_attach}
lspconfig.cssls.setup{on_attach=on_attach}

EOF

""" Custom Key mappings

"" General commands
" Shows 'crosshair'
nnoremap <leader>x  :set cursorline! cursorcolumn!<CR>
" Enables virtual editing for arbitrary cursor positions
nnoremap <leader>va :set virtualedit=all<CR>
" Disables virtual editing for arbitrary cursor positions
nnoremap <leader>vn :set virtualedit=<CR>
" Toggles search highlighting with CTRL-/
nnoremap <silent> <c-_> :set hlsearch!<cr>

"" Plugin specific commands
" denite
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select').'j'
endfunction

nnoremap <Space>
\ :Commands<CR>
nnoremap <leader>f
\ :Files<CR>
nnoremap <leader>b
\ :Buffers<CR>
nnoremap <leader>h
\ :History:<CR>

" Enables NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>

" Clang-Format settings
let g:clang_format#code_style = "file"

" Color palette
colorscheme gruvbox

" Disable unused providers
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0
