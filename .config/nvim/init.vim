call plug#begin()
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'joshdick/onedark.vim'
Plug 'preservim/nerdcommenter'
Plug 'preservim/nerdtree'
call plug#end()
set nocompatible
filetype plugin indent on
set laststatus=2
set autoread
set noswapfile
set nowritebackup
set nobackup
let mapleader=","  " <Leader> -> ,
set visualbell
set mouse=a
set cursorline " Highlight current cursor line
set showmode
set hidden
set wildmenu
set number relativenumber
set nowrap
" Set color scheme
colorscheme onedark

" Credit : Andrea Pavoni        <https://github.com/andreapavoni/dotfiles>
set ruler
set expandtab   
set ts=2
set softtabstop=2
set shiftwidth=2
set list
set listchars=""
set list listchars=tab:»·,trail:·
set scrolloff=5
set backspace=indent,eol,start
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,*.git,*.rbc,*.scs?c

set nohlsearch
set incsearch
set ignorecase
set smartcase

noremap <Up> <Esc>
noremap <Down> <Esc>
noremap <Left> <Esc>
noremap <Right> <Esc>


nmap K <Nop>

map S :%s//g<Left><Left>

au FileType python set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79
au FileType make set noexpandtab

au BufRead,BufNewFile {Gemfile,Rakefile,VagrantFile,Thorfile,config.ru} set ft=ruby
au BufNewFile,BufRead *.{json,es6} set ft=javascript

" Set all my custom shell filetypes
au BufNewFile,BufRead *.{bashrc,bash_profile,zshrc,aliasrc,keybindsrc,sh} set ft=sh

set ff=unix
let NERDTreeIgnore=['\.rbc$', '\~$']
let NERDTreeHijackNetrw=1
let g:NERDTreeChDirMode = 2
let g:NERDTreeWinPos = "right"

let g:airline_symbols = {}
let g:airline_symbols.branch = '⎇  '
let g:airline_symbols.linenr = '␤ '
let g:airline_symbols.paste = 'ρ'

nmap <C-Up> ddkp
nmap <C-Down> ddp

vmap <C-Up> xkp`[V`]
vmap <C-Down> xp`[V`]

map   <silent> <F5> mmgg=G'm
imap  <silent> <F5> <Esc> mmgg=G'm
vmap  <tab> =
nmap  <tab> ==

noremap <S-left> :bprev<CR>
noremap <S-right> :bnext<CR>
