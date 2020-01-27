" Author: voldikss <dyzplus@gmail.com>
" GitHub: https://github.com/voldikss

let g:fnote_window_width = get(g:, 'fnote_window_width', 30)
let g:fnote_window_height = get(g:, 'fnote_window_height', 5)

command! -nargs=0 FNoteNew    call fnote#do_action('new')
command! -nargs=0 FNoteToggle call fnote#do_action('toggle')
command! -nargs=* -complete=customlist,fnote#move_complete FNoteMove   call fnote#do_action('move', <f-args>)
command! -nargs=* -complete=customlist,fnote#resize_complete FNoteResize call fnote#do_action('resize', <f-args>)
