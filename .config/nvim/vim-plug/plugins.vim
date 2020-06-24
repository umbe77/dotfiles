set nocompatible

if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

Plug 'arcticicestudio/nord-vim'

" Surround
Plug 'tpope/vim-surround'
" Better Comments
Plug 'tpope/vim-commentary'
" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Add some color
Plug 'norcalli/nvim-colorizer.lua'
Plug 'junegunn/rainbow_parentheses.vim'
" Better Syntax Support
Plug 'sheerun/vim-polyglot'
" Cool Icons
Plug 'ryanoasis/vim-devicons'
" Auto pairs for '(' '[' '{' 
Plug 'jiangmiao/auto-pairs'
" Have the file system follow you around
Plug 'airblade/vim-rooter'
" Ranger
Plug 'kevinhwang91/rnvimr', {'do': 'make sync'}
" FZF
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'junegunn/gv.vim'
" Terminal
Plug 'voldikss/vim-floaterm'
" See what keys do like in emacs
Plug 'liuchengxu/vim-which-key'

" dotnet support
Plug 'OmniSharp/omnisharp-vim'

" Intellisense
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Hskell Support
Plug 'neovimhaskell/haskell-vim'

" Hskell Hilint
Plug 'alx741/vim-hindent'

" protobuf highliting
Plug 'uarun/vim-protobuf'

call plug#end()

autocmd VimEnter *
    \ if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \|  PlugInstall --sync | q
    \| endif
