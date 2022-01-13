" Indentation Options
set autoindent
set smartindent
set shiftwidth=4
set smarttab
set tabstop=4

" Search Options
set hlsearch
set ignorecase
set smartcase
set incsearch

" Text Rendering Options
syntax enable

" User Interface Options
set title
set number relativenumber
set cursorline
set showmatch
set wildmenu

" Miscellaneous Options
set history=1000
set spell spelllang=en_us
hi clear SpellBad
hi SpellBad cterm=underline
set shell
set clipboard+=unnamed

" Mapping Options
inoremap <silent> jj <ESC>
" Auto closing
inoremap (<CR> (<CR>)<C-c>O<Tab>
inoremap (( ()<Left>
inoremap {<CR> {<CR>}<C-c>O<Tab>
inoremap {{ {}<Left>
inoremap <<< <><Left>
inoremap [ []<Left>
inoremap " ""<Left>
inoremap ' ''<Left>
inoremap ` ``<Left>
" Switch buffer
nnoremap <C-p> :bprev<CR>
nnoremap <C-n> :bnext<CR>
" Delete buffer
nnoremap <C-d> :bd<CR>
" Toggle NERDTree
nnoremap <silent><C-e> :NERDTreeToggle<CR>

" Plugins
call plug#begin('~/.vim/plugged')

" LSP
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

" LSP Auto-complete
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

" LSP golang
Plug 'mattn/vim-goimports'

" File system explorer
Plug 'preservim/nerdtree'

" All about surroundings
Plug 'tpope/vim-surround'

" Status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='angr'
