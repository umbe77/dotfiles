imap <C-h> <C-w>h
imap <C-j> <C-w>j
imap <C-k> <C-w>k
imap <C-l> <C-w>l

let mapleader=" "
nnoremap <Space> <Nop>

vnoremap < <gv
vnoremap > >gv

if exists('g:vscode')
    nnoremap <silent> <TAB> :tabnext<CR>
    nnoremap <silent> <S-TAB> :tabprevious<CR>
else

    inoremap jk <Esc>
    inoremap kj <Esc>

    " Easy navigation between Buffers

    " TAB in general mode will move to text buffer
    nnoremap <silent> <TAB> :bnext<CR>
    " SHIFT-TAB will go back
    nnoremap <silent> <S-TAB> :bprevious<CR>
    " Move selected line / block of text in visual mode
    " shift + k to move up
    " shift + j to move down
    xnoremap K :move '<-2<CR>gv-gv
    xnoremap J :move '>+1<CR>gv-gv
    " Save Easy way
    nnoremap <silent> <C-s> :w<CR>

    " TAB Completion
    inoremap <silent> <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

    " Better window navigation
    nnoremap <C-h> <C-w>h
    nnoremap <C-j> <C-w>j
    nnoremap <C-k> <C-w>k
    nnoremap <C-l> <C-w>l
    
    " Use alt + hjkl to resize windows
    nnoremap <silent> <M-j>    :resize -2<CR>
    nnoremap <silent> <M-k>    :resize +2<CR>
    nnoremap <silent> <M-h>    :vertical resize -2<CR>
    nnoremap <silent> <M-l>    :vertical resize +2<CR>   
endif
