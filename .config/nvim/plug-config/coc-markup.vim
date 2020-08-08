" Create markmap from the whole file
nmap <Leader>mm <Plug>(coc-markmap-create)
" Create markmap from the selected lines
vmap <Leader>mm <Plug>(coc-markmap-create-v)
command! -range=% Markmap CocCommand markmap.create <line1> <line2>
