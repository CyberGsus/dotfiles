" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall
	autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

" Better Syntax Support
Plug 'sheerun/vim-polyglot'
" File Explorer


" Auto pairs for '(' '[' '{'
Plug 'jiangmiao/auto-pairs'

" tpope essentials
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'

" Theming
Plug 'itchyny/lightline.vim'
Plug 'hzchirs/vim-material'
Plug 'joshdick/onedark.vim'
Plug 'sonph/onehalf', { 'rtp': 'vim/' }

Plug 'leafgarland/typescript-vim'


" Completion
Plug 'neoclide/coc.nvim', { 'branch' : 'release' }

" FZF && vim-rooter
Plug 'junegunn/fzf', { 'do' : { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter'

Plug 'christoomey/vim-sort-motion'

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }

Plug 'turbio/bracey.vim'

Plug 'sophacles/vim-processing'
" Plug 'junegunn/vim-emoji'
call plug#end()


let g:rainbow_active = 1
