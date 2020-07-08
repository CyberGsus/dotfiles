

function! FixStyle()
  let line = getline('.')
  if line !~ '^\s*#'
    execute "silent! s/\\\>([^)]/ \\0/g" | " main (void) => main (void)
  endif
  "  execute "silent! %s/\\\>[=+-<>/!]\\+/ \\0/g" | " a+b => a +b
endfunction


function! CWrite()
  normal mm
  %call FixStyle()
  normal 'm
endfunction


imap <leader>main jk:r $HOME/.snippets/c/main.c<cr>o<tab>
imap <leader>inc< #include <>jki
imap <leader>inc" #include ""jki
iabbr /* /* */jk2hi
augroup c_cpp_languages
  autocmd BufWritePre *.{c,h,cpp} call CWrite()
augroup END
