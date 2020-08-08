if has('nvim')
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
if has('termguicolors')
  let &t_8f="\<esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

source $HOME/.config/nvim/themes/lightline.vim

if (g:colors_name ==# 'material')
" Material theme
source $HOME/.config/nvim/themes/material.vim
endif

if (g:colors_name ==# 'onedark')
source $HOME/.config/nvim/themes/onedark.vim
endif


hi Comment cterm=italic
hi Normal  ctermbg='NONE' guibg='NONE'
