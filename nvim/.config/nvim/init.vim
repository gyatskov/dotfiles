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
Plug 'Shougo/denite.nvim'

" Extended regex syntax
Plug 'othree/eregex.vim'

" Language servers
Plug 'dense-analysis/ale'

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
Plug 'vim-syntastic/syntastic'

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
" Enables NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>

" ALE mappings
nn <silent> <M-d> :ALEGoToDefinition<cr>
nn <silent> <M-r> :ALEFindReferences<cr>
nn <silent> <M-a> :ALESymbolSearch<cr>
nn <silent> <M-h> :ALEHover<cr>

" Syntastic settings
let g:syntastic_cpp_compiler = "clang++"
let g:syntastic_cpp_compiler_options = " -std=c++11"

let g:clang_format#code_style = "file"

" Color palette
colorscheme gruvbox
