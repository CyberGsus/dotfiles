imap <leader>main jk:r $HOME/.snippets/python/main.py<cr>o
imap <leader>def jk:r $HOME/.snippets/python/def.py<cr>f)ci(
imap <leader>asyncd jk:r $HOME/.snippets/python/asyncd.py<cr>f)ci(


augroup python_autoformat
  au FileWritePost <buffer> call s:format()
  function! Format()
    silent! !black -l 80 %
    e!
  endfunction

  nmap <leader><tab> :call Format()<cr>
augroup END

iabbrev iff if:jki<space>
set ts=4 sts=4 sw=4
