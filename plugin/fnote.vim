" Author: voldikss <dyzplus@gmail.com>
" GitHub: https://github.com/voldikss

let g:fnote_window_maxwidth = get(g:, 'fnote_window_maxwidth', v:null)
let g:fnote_window_maxheight = get(g:, 'fnote_window_maxheight', v:null)

command! -nargs=0 -range FNoteNew  call fnote#new(<line1>, <line2>, <count>)
command! -nargs=0        FNoteToggle call fnote#toggle()
command! -nargs=* -complete=customlist,fnote#move_complete FNoteMove   call fnote#move(<f-args>)
command! -nargs=* -complete=customlist,fnote#resize_complete FNoteResize call fnote#resize(<f-args>)
