"                       _         _  __           _
"                      (_)____   (_)/ /_  _   __ (_)____ ___
"                     / // __ \ / // __/ | | / // // __ `__ \
"                    / // / / // // /_ _ | |/ // // / / / / /
"                   /_//_/ /_//_/ \__/(_)|___//_//_/ /_/ /_/
"                   

set nocompatible

call plug#begin(stdpath('data') . '/plugged')

Plug 'ap/vim-css-color'

Plug 'sheerun/vim-polyglot'

Plug 'ryanoasis/vim-devicons'

Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'

"Plug 'dracula/vim', { 'as': 'dracula' }
"Plug 'morhetz/gruvbox'
Plug 'arcticicestudio/nord-vim'
"Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

Plug 'OmniSharp/omnisharp-vim'
Plug 'OrangeT/vim-csharp'
Plug 'dense-analysis/ale'

Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/async.vim'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

call plug#end()

filetype plugin indent on
syntax enable

set completeopt=longest,menuone,noinsert,noselect,preview

"set colorscheme
"colorscheme gruvbox
"let g:gruvbox_contrast_dark = "hard"
"colorscheme onedark
"colorscheme dracula
colorscheme nord
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
set cursorline
set showmatch
set lazyredraw
set ignorecase
set previewheight=5

inoremap <expr> <Tab> pumvisible() ? '<C-n>' :
                        \ getline('.')[col('.')-2] =~# '[[:alnum:].-_#$]' ? '<C-x><C-o>' : '<Tab>'


"Airline configurations
"let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

noremap <Leader>y "*y
noremap <Leader>p "*p
noremap <Leader>Y "+y
noremap <Leader>P "+p 

au BufNewFile,BufRead /*.rasi setf css
