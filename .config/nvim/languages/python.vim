imap <leader>main jk:r $HOME/.snippets/python/main.py<cr>o
imap <leader>def jk:r $HOME/.snippets/python/def.py<cr>f)ci(
imap <leader>asyncd jk:r $HOME/.snippets/python/asyncd.py<cr>f)ci(
imap <leader>du ____jkhi


augroup python_autoformat
  function! Format()
    " system('black', '-l', string(&tw), expand('%'))
    silent!
    silent! !black -l 79 %
    e!
  endfunction

  au FileWritePost *.py call Format()
  nmap <leader><tab> :call Format()<cr>
augroup END

iabbrev iff if:jki<space>
set ts=4 sts=4 sw=4 tw=78
