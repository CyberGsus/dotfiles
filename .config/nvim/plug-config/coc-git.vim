nnoremap <silent> <leader>g :<c-u>CocList --normal gstatus<CR>
map [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)
" show chunk diff at current position
nmap <leader>gch <Plug>(coc-git-chunkinfo)
" show commit contains current position
nmap <leader>gsc <Plug>(coc-git-commit)
" create text object for git chunks
omap ig <Plug>(coc-git-chunk-inner)
xmap ig <Plug>(coc-git-chunk-inner)
omap ag <Plug>(coc-git-chunk-outer)
xmap ag <Plug>(coc-git-chunk-outer)

nnoremap <silent> <leader>gr :CocCommand git.refresh<CR>
nmap <silent> <leader>wr ,w,gr
