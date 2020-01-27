" Author: voldikss <dyzplus@gmail.com>
" GitHub: https://github.com/voldikss

" Script level variables:
" * s:fnote_win
" * s:fnote_buf
" * s:fnote_win_opts

function! fnote#do_action(action, ...) abort
  if !exists('s:fnote_buf')
    let s:fnote_buf = -1
  endif
  if !exists('s:fnote_win')
    let s:fnote_win = -1
  endif
  if a:action ==# 'new'
    call s:new()
  elseif a:action ==# 'toggle'
    call s:toggle()
  elseif a:action ==# 'move'
    call s:move(a:1, a:2)
  elseif a:action ==# 'resize'
    call s:resize(a:1, a:2)
  endif
endfunction

function! s:new() abort
  call s:update_buflines()
  if !s:winexists(s:fnote_win)
    call s:open_win()
  endif
endfunction

function! s:toggle() abort
  if s:winexists(s:fnote_win)
    " storage old window config
    let s:fnote_win_opts = nvim_win_get_config(s:fnote_win)
    let winnr = win_id2win(s:fnote_win)
    execute winnr . ' wincmd c'
  elseif !bufexists(s:fnote_buf)
    call s:update_buflines()
    call s:open_win()
  else
    call s:open_win()
  endif
endfunction

function! s:update_buflines() abort
  if !bufexists(s:fnote_buf)
    let s:fnote_buf = nvim_create_buf(v:false, v:true)
  endif
  call nvim_buf_set_lines(s:fnote_buf, 0, -1, v:false, [])
  call nvim_buf_set_lines(s:fnote_buf, 0, -1, v:false, split(@", "\n"))
  call nvim_buf_set_option(s:fnote_buf, 'filetype', &filetype)
  call nvim_buf_set_var(s:fnote_buf, 'fnote', v:true)
endfunction

function! s:open_win() abort
  if !exists('s:fnote_win_opts')
    let [row, col] = s:floating_win_pos(
      \ g:fnote_window_width,
      \ g:fnote_window_height
      \ )
    let s:fnote_win_opts = {
      \ 'relative': 'editor',
      \ 'anchor': 'NW',
      \ 'row': row,
      \ 'col': col,
      \ 'width': g:fnote_window_width,
      \ 'height': g:fnote_window_height,
      \ 'style':'minimal'
      \ }
  endif
  let s:fnote_win = nvim_open_win(s:fnote_buf, v:false, s:fnote_win_opts)
  call nvim_win_set_option(s:fnote_win, 'wrap', v:true)
endfunction

function! s:move(direction, interval) abort
  if !s:winexists(s:fnote_win)
    return
  endif
  let s:fnote_win_opts = nvim_win_get_config(s:fnote_win)
  if a:direction ==# 'y'
    let s:fnote_win_opts.row -= a:interval
  elseif a:direction ==# 'x'
    let s:fnote_win_opts.col += a:interval
  endif
  call nvim_win_set_config(s:fnote_win, s:fnote_win_opts)
endfunction

function! s:resize(dimension, interval) abort
  if !s:winexists(s:fnote_win)
    return
  endif
  if a:dimension ==# 'x'
    let s:fnote_win_opts.width += a:interval
    if s:fnote_win_opts.width <= 0
      return
    endif
  elseif a:dimension ==# 'y'
    let s:fnote_win_opts.height += a:interval
    if s:fnote_win_opts.height <= 0
      return
    endif
  endif
  call nvim_win_set_config(s:fnote_win, s:fnote_win_opts)
endfunction

function! s:floating_win_pos(width, height) abort
    let curr_pos = getpos('.')
    let row = curr_pos[1] - line('w0')
    if row <= g:fnote_window_height
      let row = max([line('w$') - g:fnote_window_height - 1, 1])
    else
      let row = 1 " next to tabline
    endif
    let col = &columns - g:fnote_window_width
  return [row, col]
endfunction

function! s:winexists(winid) abort
  return len(getwininfo(a:winid)) > 0
endfunction

function! fnote#move_complete(...) abort
  return ['up', 'right', 'down', 'left']
endfunction

function! fnote#resize_complete() abort
  return ['x', 'y']
endfunction
