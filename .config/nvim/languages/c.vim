
function FixStyle()
  execute "silent! %s/\\\>([^)]/ \\0/g" | " main (void) => main (void)
  "  execute "silent! %s/\\\>[=+-<>/!]\\+/ \\0/g" | " a+b => a +b
endfunction


function CWrite()
  normal mm
  call FixStyle()
  execute "normal <leader><tab>" | " auto-indent, see ../init.vim
  normal `m
endfunction


imap <leader>main jk:r $HOME/.snippets/c/main.c<cr>o<tab>
imap <leader>inc< #include <>jki
imap <leader>inc" #include ""jki
iabbr /* /* */jk2hi
augroup languages_c
  autocmd BufWritePre * call CWrite ()
augroup END
