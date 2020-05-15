augroup languages
  autocmd BufRead,BufNewFile .zsh* set ft=zsh
  autocmd FileType {c,javascript,cpp} iabbrev <buffer> iff if ()<left>
  autocmd FileType c source ~/.config/nvim/languages/c.vim
  autocmd FileType python source ~/.config/nvim/languages/python.vim
  autocmd BufWritePost *.tex execute "!pdflatex %"
augroup END
