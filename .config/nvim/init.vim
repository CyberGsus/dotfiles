source $HOME/.config/nvim/vim-plug/plugins.vim
source $HOME/.config/nvim/general/settings.vim
source $HOME/.config/nvim/keys/mappings.vim
"" Theme
let g:material_style = 'oceanic'
colorscheme vim-material
set background=dark
source $HOME/.config/nvim/themes/init.vim

" Completion
source $HOME/.config/nvim/plug-config/init.vim


" LAST THING SOURCED
source $HOME/.config/nvim/general/post.vim
