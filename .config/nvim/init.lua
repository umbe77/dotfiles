require('packer_plugins')
require('nv-utils')
require('globals')
require('keymappings')
require('settings')
require('colorscheme')

require('nv-colorizer')

-- Plugins
require('nv-treesitter')
require('nv-indentline')
require('nv-comment')

require('nv-barbar')
require('nv-nvimtree')
require('nv-compe')

require('nv-lspkind')
require('nv-lightbulb')

vim.cmd('source ~/.config/nvim/vim/nv-wichkey.vim')
vim.cmd('source ~/.config/nvim/vim/functions.vim')
vim.cmd('source ~/.config/nvim/vim/nv-minimap.vim')

--Telescope
require('nv-telescope')

require('nv-gitsigns')
require('nv-gitblame')

require('lsp')
require('lsp.lua-ls')
require('lsp.virtual_text')
require('lsp.go-ls')
require('lsp.js-ts-ls')
require('lsp.omnisharp')
require('lsp.bash-ls')
require('lsp.efm-general-ls')
