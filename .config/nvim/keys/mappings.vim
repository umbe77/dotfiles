imap <C-h> <C-w>h
imap <C-j> <C-w>j
imap <C-k> <C-w>k
imap <C-l> <C-w>l

let mapleader=" "
nnoremap <Space> <Nop>

vnoremap < <gv
vnoremap > >gv

if exists('g:vscode')
else

    inoremap jk <Esc>
    inoremap kj <Esc>

    " Easy navigation between Buffers
    nnoremap <silent> <TAB> :tabnext<CR>
    nnoremap <silent> <S-TAB> :tabprevious<CR>

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
