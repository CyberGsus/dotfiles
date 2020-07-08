augroup languages
  autocmd BufRead,BufNewFile .zsh* set ft=zsh


  autocmd FileType {c,javascript,cpp} iabbrev if if ()jki
  autocmd FileType {c,cpp} source ~/.config/nvim/languages/c.vim
  autocmd FileType python source ~/.config/nvim/languages/python.vim
  autocmd BufWritePost *.tex execute "!pdflatex %"


  au Filetype make setlocal noexpandtab

  au BufRead,BufNewFile {Gemfile,Rakefile,VagrantFile,Thorfile,config.ru} set ft=ruby
  au BufNewFile,BufRead *.{json,es6} set ft=javascript

  " Set tmux files
  au BufRead,BufNewFile .tmux* set ft=tmux

  " Set all my custom shell filetypes
  au BufNewFile,BufRead *.{bashrc,bash_profile,sh}
        \ set ft=sh

  " Set dockerfile filetypes
  au BufNewFile,BufRead Dockerfile* set ft=dockerfile

augroup END
