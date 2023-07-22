set termguicolors
" colorscheme onedark
" colorscheme catppuccin 
set cursorline
let g:vim_markdown_folding_disabled = 1
set clipboard+=unnamedplus
" neovide settings
#set guifont=FantasqueSansMono\ Nerd\ Font:h7
#let g:neovide_cursor_vfx_mode = "railgun"
autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE
" for journaling
#autocmd VimEnter */journal/**   0r ~/.config/vim/templates/journal.skeleton
" set header title for journal & enter writing mode
"function! JournalMode()
"    execute 'normal gg'
"    let filename = '#' . ' ' . expand('%:r')
"    call setline(1, filename)
"    execute 'normal o'
"endfunction

" workflow for daily journal
"augroup journal
"    autocmd!
"
"    " populate journal template
"    autocmd VimEnter */journal/**   0r ~/.config/nvim/templates/journal.skeleton
"
"    " set header for the particular journal
"    autocmd VimEnter */journal/**   :call JournalMode()
"
"augroup END
