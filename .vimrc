"
"                         _   __ (_)____ ___   _____ _____
"                        | | / // // __ `__ \ / ___// ___/
"                      _ | |/ // // / / / / // /   / /__
"                     (_)|___//_//_/ /_/ /_//_/    \___/
"

set nocompatible

filetype plugin indent on
syntax enable

set completeopt=longest,menuone,noinsert,noselect,preview

set background=dark

set fileencoding=utf-8
set encoding=utf-8

set path+=**
set number relativenumber

set hidden
set tabstop=4 shiftwidth=4 expandtab "tab equals to 4 char
set backspace=indent,eol,start
set smartcase
set smarttab
set autoindent

set showcmd
"set cursorline
set showmatch
set lazyredraw
set ignorecase
set previewheight=5

inoremap <expr> <Tab> pumvisible() ? '<C-n>' :
                        \ getline('.')[col('.')-2] =~# '[[:alnum:].-_#$]' ? '<C-x><C-o>' : '<Tab>'


noremap <Leader>y "*y
noremap <Leader>p "*p
noremap <Leader>Y "+y
noremap <Leader>P "+p 

