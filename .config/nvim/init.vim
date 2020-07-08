set path+=**
au!
" Install vim-plug
if empty (glob ('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  q!
endif


call plug#begin('~/.vim/plugged')
" Theme
" Plug 'bling/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
Plug 'itchyny/lightline.vim'
Plug 'hzchirs/vim-material'
Plug 'preservim/nerdtree'               " File Tree
Plug 'prettier/vim-prettier'
Plug 'kristijanhusak/vim-carbon-now-sh'
" Essential!!
" From christoomey <https://www.youtube.com/watch?v=wlR5gYd6um0&t=1545s>

" Plug 'integralist/vim-mypy'
Plug 'tpope/vim-repeat'                 " Enables repeating plug commands
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'               " Change surrounding stuff (quotes, bquotes)
Plug 'tpope/vim-commentary'             " Commenting lines
Plug 'tpope/vim-fugitive'
Plug 'neoclide/coc.nvim', { 'branch' : 'release'}
Plug 'lyuts/vim-rtags'
" Plug 'ycm-core/YouCompleteMe'
" Plug 'vim-syntastic/syntastic'
call plug#end()
packloadall

set nocompatible
filetype plugin indent on

nnoremap <C-m> :NERDTreeToggle<CR>
if has ('nvim')
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

if has ('termguicolors')
  set termguicolors
endif


set laststatus=2
set autoread
set noswapfile
set nowritebackup
set nobackup
let mapleader=","  " <Leader> -> ,
set visualbell
" set mouse=a
set cursorline " Highlight current cursor line
set noshowmode
set hidden
set wildmenu
set number relativenumber
set wrap

" Set color scheme
let g:material_style='oceanic'
let g:lightline = {
      \ 'colorscheme' : 'material',
      \ 'active' : {
      \ 'left' : [ [ 'mode', 'paste', ],
      \        [ 'gitbranch', 'readonly', 'filename', 'modified' ]
      \ ],
      \ 'right' : [
      \         [ 'lineinfo' ],
      \         [ 'charvaluehex' ],
      \         [ 'fileformat', 'fileencoding', 'filetype' ],
      \ ],
      \},
      \ 'component' : {
      \   'filename' : '%f',
      \   'modified' : '%m',
      \   'charvaluehex' : '0x%B'
      \ },
      \ 'component_function' : {
      \ 'gitbranch' : 'fugitive#head',
      \ }
      \ }
let g:lightline.separator = {
      \   'left': '', 'right': ''
      \}
let g:lightline.subseparator = {
      \   'left': '', 'right': ''
      \}

let g:javascript_plugin_jsdoc = 1
" let g:airline_theme='material'
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

" Break bad habits!
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>
inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>

" nmap K <Nop>

map S :%s//g<Left><Left>

au FileType python set tabstop=4 softtabstop=4 shiftwidth=4
au FileType make set noexpandtab

au BufRead,BufNewFile {Gemfile,Rakefile,VagrantFile,Thorfile,config.ru} set ft=ruby
au BufNewFile,BufRead *.{json,es6} set ft=javascript

" Set tmux files
au BufRead,BufNewFile .tmux* set ft=tmux

" Set all my custom shell filetypes
au BufNewFile,BufRead *.{bashrc,bash_profile,zshrc,aliasrc,keybindsrc,sh} set ft=sh

" Set dockerfile filetypes
au BufNewFile,BufRead Dockerfile* set ft=dockerfile

if exists ('+colorcolumn')
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

" vmap <C-Up> xkp`[V`]
" vmap <C-Down> xp`[V`]

map   <silent> <F5> mmgg=G'm
imap  <silent> <F5> <Esc> mmgg=G'm
vmap  <tab> =
nmap  <tab> ==

noremap <S-left> :bprev<CR>
noremap <S-right> :bnext<CR>
" Moving lines around
nnoremap - ddp
nnoremap _ ddkP
" Remapping tab navigation
" nnoremap hT :tabnext
" nnoremap ht :tabn

inoremap <leader><c-u> <Esc>viwUi
inoremap <leader><c-d> <Esc>ddi
" File browsing (default vim plugin)
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'


" ALE
let g:ale_fix_on_save=1
let g:ale_fixers = {
      \ 'javascript' : [
      \ 'eslint',
      \ ],
      \ 'python' : [
      \ 'autopep8',
      \ 'trim_whitespace',
      \ 'remove_trailing_lines',
      \ ],
      \}

" Bind F8 to fixing problems with ALE
nmap <F8> <Plug>(ale_fix)
" Snippets

nnoremap <leader>html :-1read $HOME/.vim/.skeleton.html<CR>3jwf>cit

" set makeprg=bundle\ exec\ rspec\ -f\ QuickfixFormatter

" Syntastic config
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_python_checkers = ['pycodestyle', 'mypy']

" Include brackets
" inoremap " ""<left>
" inoremap ' ''<left>
" inoremap [ []<left>
" inoremap ( ()<left>
inoremap { {}<left>
inoremap {; {};<left><left>
inoremap {<CR> {<CR>}<esc>O
inoremap {;<CR> {<CR>};<ESC>O
" Edit my vimrc and go back to coding
nnoremap <leader>evv :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>evh :split $MYVIMRC<cr>

" Disable normal escape and force myself to use jk
inoremap <esc> <nop>
inoremap jk <Esc>
" Auto indent
nnoremap <leader><tab> mmgg=G`m
source $HOME/.config/nvim/languages.vim

map <C-j> :cn<CR>
map <C-k> :cp<CR>


function! RemoveWhiteSpaces()
  normal! mm
  :%s/\s*$//g
  normal! 'm
endfunction

au BufWritePre * call RemoveWhiteSpaces()

nnoremap ]l :try<bar>lnext<bar>catch /^Vim\%((\a\+)\)\=:E\%(553\<bar>42\):/<bar>lfirst<bar>endtry<cr>
nnoremap [l :try<bar>lprev<bar>catch /^Vim\%((\a\+)\)\=:E\%(553\<bar>42\):/<bar>lfirst<bar>endtry<cr>

let @x='^"+y$'

" Remove background
hi Normal guibg='NONE'


function! GoYCM()
  nnoremap <buffer> <silent> <leader>gd :YcmCompleter GoTo<CR>
  nnoremap <buffer> <silent> <leader>gr :YcmCompleter GoToReferences<CR>
  nnoremap <buffer> <silent> <leader>rr :YcmCompleter RefactorRename<space>
endfunction

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

fun! GoCoC()
  inoremap <buffer> <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()

  inoremap <buffer> <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
  inoremap <buffer> <silent><expr> <C-space> coc#refresh()

  " GoTo code navigation
  nmap <buffer> <leader>gd <Plug>(coc-definition)
  nmap <buffer> <leader>gy <Plug>(coc-type-definition)
  nmap <buffer> <leader>gi <Plug>(coc-implementation)
  nmap <buffer> <leader>gr <Plug>(coc-references)
endfunction


" source $HOME/.config/nvim/plug-config/coc.vim
