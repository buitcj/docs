inoremap jk <ESC>

set path=$PWD/**
syntax on
set tabstop=2 softtabstop=4
set shiftwidth=2
set expandtab
set smartindent
set nu

set smartcase
set noswapfile
set incsearch

set colorcolumn=80

"Goto file while in normal mode
map <C-t> <Esc><Esc>:Files!<CR>
"Find text in file while in insert mode
inoremap <C-t> <Esc><Esc>:BLines!<CR>
"Open git info for this file
map <C-g> <Esc><Esc>:BCommits!<CR>

call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'morhetz/gruvbox'
Plug 'jremmen/vim-ripgrep'
"Plug 'tpop/vim-fugitive'
Plug 'vim-utils/vim-man'
Plug 'lyuts/vim-rtags'
Plug 'kien/ctrlp.vim'
"Plug 'Valloric/YouCompleteMe'
Plug 'mbbill/undotree'
call plug#end()
