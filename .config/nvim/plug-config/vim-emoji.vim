" augroup emoji
"   inoremap <silent> jk <esc>:%s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g<cr>
"   inoremap <silent> kj <esc>:%s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g<cr>
  
" augroup end


