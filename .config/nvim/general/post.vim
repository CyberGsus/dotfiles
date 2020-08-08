" This is always last thing sourced
" Fix Format command
" au FileType javascript :command! -nargs=0 Format :CocCommand prettier.formatFile
" au FileType typescript :command! -nargs=0 Format :CocCommand prettier.formatFile
" au FileType vue :command! -nargs=0 Format :CocCommand prettier.formatFile
au FileWritePre * :Format

" Refresh editor
au FileWritePost * :e!
