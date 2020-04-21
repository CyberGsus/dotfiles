
" Install vim-plug
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs 
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC 
  q!
endif



call plug#begin()
" Theme
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'hzchirs/vim-material'
Plug 'preservim/nerdtree'               " File Tree
" Essential!!
" From christoomey <https://www.youtube.com/watch?v=wlR5gYd6um0&t=1545s>

Plug 'tpope/vim-repeat'                 " Enables repeating plug commands
Plug 'tpope/vim-surround'               " Change surrounding stuff (quotes, bquotes)
Plug 'tpope/vim-commentary'             " Commenting lines
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'christoomey/vim-titlecase'        " Change titlecase instantly
Plug 'christoomey/vim-sort-motion'      " Sorting faster
Plug 'christoomey/vim-system-copy'      " Copying to system buffer
" Plug 'kana/vim-textobj-indent'          " Better indenting

" Plug 'neoclide/coc.nvim', { 'branch' : 'release' }   " Autocompletion
call plug#end()


nmap <C-n> :NERDTreeToggle<CR>
if has('nvim')
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

if has('termguicolors')
  set termguicolors
endif

set nocompatible
filetype plugin indent on

set laststatus=2
set autoread
set noswapfile
set nowritebackup
set nobackup
let mapleader=","  " <Leader> -> ,
set visualbell
" set mouse=a
set cursorline " Highlight current cursor line
set showmode
set hidden
set wildmenu
set number relativenumber
set wrap
" Set color scheme
let g:material_style='oceanic'
let g:airline_theme='material'
set background=dark
colorscheme vim-material

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

au FileType python set tabstop=4 softtabstop=4 shiftwidth=4 
au FileType make set noexpandtab

au BufRead,BufNewFile {Gemfile,Rakefile,VagrantFile,Thorfile,config.ru} set ft=ruby
au BufNewFile,BufRead *.{json,es6} set ft=javascript

" Set all my custom shell filetypes
au BufNewFile,BufRead *.{bashrc,bash_profile,zshrc,aliasrc,keybindsrc,sh} set ft=sh

" Set dockerfile filetypes
au BufNewFile,BufRead Dockerfile* set ft=dockerfile

if exists('+colorcolumn')
  set colorcolumn=80
  highlight ColorColumn ctermbg=lightgrey
endif

" set ff=unix
" let NERDTreeIgnore=['\.rbc$', '\~$']
" let NERDTreeHijackNetrw=1
" let g:NERDTreeShowHidden=1
" let g:NERDTreeChDirMode = 2
" let g:NERDTreeWinPos = "left"

let g:airline_symbols = {}
let g:airline_symbols.branch = '⎇  '
let g:airline_symbols.linenr = '␤ '
let g:airline_symbols.paste = 'ρ'

nmap <C-Z> NERDTreeToggle
nmap <C-Up> ddkP
nmap <C-Down> ddp

vmap <C-Up> xkp`[V`]
vmap <C-Down> xp`[V`]

map   <silent> <F5> mmgg=G'm
imap  <silent> <F5> <Esc> mmgg=G'm
vmap  <tab> =
nmap  <tab> ==

noremap <S-left> :bprev<CR>
noremap <S-right> :bnext<CR>
if exists('g:vscode')
  unmap <C-K>
endif

" Important!
set path+=**



" File browsing (default vim plugin)
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

" Snippets

nnoremap ,html :-1read $HOME/.vim/.skeleton.html<CR>3jwf>a

" set makeprg=bundle\ exec\ rspec\ -f\ QuickfixFormatter

" Include brackets
inoremap " ""<left>
inoremap ' ''<left>
inoremap [ []<left>
inoremap ( ()<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

