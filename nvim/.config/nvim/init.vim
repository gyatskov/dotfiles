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
Plug 'rust-lang/rust.vim'

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
lspconfig.ccls.setup {
    init_options = {
        index = {
            threads = 0;
        };
    }
}
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
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("v", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
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

-- Use a loop to conveniently both setup defined servers 
-- and map buffer local keybindings when the language server attaches
local servers = { "ccls", "rust_analyzer" }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup { on_attach = on_attach }
end
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

" Enables NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>

" Clang-Format settings
let g:clang_format#code_style = "file"

" Color palette
colorscheme gruvbox
