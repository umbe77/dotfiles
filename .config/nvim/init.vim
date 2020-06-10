"                       _         _  __           _
"                      (_)____   (_)/ /_  _   __ (_)____ ___
"                     / // __ \ / // __/ | | / // // __ `__ \
"                    / // / / // // /_ _ | |/ // // / / / / /
"                   /_//_/ /_//_/ \__/(_)|___//_//_/ /_/ /_/
"                   
"
source $HOME/.config/nvim/vim-plug/plugins.vim
source $HOME/.config/nvim/general/settings.vim
source $HOME/.config/nvim/general/functions.vim
source $HOME/.config/nvim/keys/mappings.vim

if exists('g:vscode')
else
    source $HOME/.config/nvim/themes/syntax.vim
    source $HOME/.config/nvim/themes/airline.vim
    source $HOME/.config/nvim/plug-config/fzf.vim
    source $HOME/.config/nvim/plug-config/rnvimr.vim
    source $HOME/.config/nvim/plug-config/rainbow.vim
    source $HOME/.config/nvim/plug-config/gitgutter.vim
    luafile $HOME/.config/nvim/lua/plug-colorizer.lua
    source $HOME/.config/nvim/plug-config/floaterm.vim
    source $HOME/.config/nvim/plug-config/vim-rooter.vim
    source $HOME/.config/nvim/plug-config/coc.vim
    source $HOME/.config/nvim/keys/which-key.vim
endif
