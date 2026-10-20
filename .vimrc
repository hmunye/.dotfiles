syntax on
filetype plugin on

let g:netrw_browse_split = 0
let g:netrw_banner = 0
let g:netrw_winsize = 25

nnoremap <silent> - :Ex<CR>
nnoremap <silent> <Esc> :nohlsearch<CR>
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap <C-k> :cnext<CR>zz
nnoremap <C-j> :cprev<CR>zz
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

set mouse=
set guicursor=
set number
set relativenumber
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set smartcase
set ignorecase
set nohlsearch
set incsearch
set nowrap
set noswapfile
set nobackup
set noundofile
set clipboard=unnamedplus
set scrolloff=10
set signcolumn=yes
set updatetime=50
set timeoutlen=300
set colorcolumn=80
set termguicolors
set background=dark

colorscheme quiet
