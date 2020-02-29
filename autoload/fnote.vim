" ============================================================================
" FileName: fnote.vim
" Author: voldikss <dyzplus@gmail.com>
" GitHub: https://github.com/voldikss
" ============================================================================

let s:fnotebuf = -1
let s:fnotewin = -1

function! fnote#new(line1, line2, count) abort
  let linelist = s:get_content(a:line1, a:line2, a:count)
  call s:bufcreate(linelist)
  if s:winexists(s:fnotewin)
    call s:resize_win(s:fnotewin)
  else
    let s:fnotewin = s:open_win()
  endif
endfunction

function! fnote#toggle() abort
  if s:winexists(s:fnotewin)
    call nvim_win_close(s:fnotewin, v:true)
  elseif !bufexists(s:fnotebuf)
    call s:bufcreate()
    call s:open_win()
  else
    call s:open_win()
  endif
endfunction

function! fnote#move(direction, interval) abort
  if !s:winexists(s:fnotewin)
    return
  endif
  let opts = nvim_win_get_config(s:fnotewin)
  if a:direction ==# 'y'
    let opts.row += a:interval
  elseif a:direction ==# 'x'
    let opts.col += a:interval
  endif
  let opts.style = 'minimal'
  call nvim_win_set_config(s:fnotewin, opts)
  call s:nvim_win_set_option(s:fnotewin)
endfunction

function! fnote#resize(dimension, interval) abort
  if !s:winexists(s:fnotewin)
    return
  endif
  let opts = nvim_win_get_config(s:fnotewin)
  if a:dimension ==# 'x'
    let opts.width += a:interval
    if opts.width <= 0
      return
    endif
  elseif a:dimension ==# 'y'
    let opts.height += a:interval
    if opts.height <= 0
      return
    endif
  endif
  let opts.style = 'minimal'
  call nvim_win_set_config(s:fnotewin, opts)
  call s:nvim_win_set_option(s:fnotewin)
endfunction

function! s:get_content(start, end, count) abort
  if a:count != -1
    let linelist = []
    for lnum in range(a:start, a:end)
      call add(linelist, getline(lnum))
    endfor
  else
    let linelist = split(@", "\n")
  endif
  return linelist
endfunction

function! s:bufcreate(linelist) abort
  if !bufexists(s:fnotebuf)
    let s:fnotebuf = nvim_create_buf(v:false, v:true)
  endif
  call nvim_buf_set_lines(s:fnotebuf, 0, -1, v:false, [])
  call nvim_buf_set_lines(s:fnotebuf, 0, -1, v:false, a:linelist)
  call nvim_buf_set_option(s:fnotebuf, 'filetype', &filetype)
  call nvim_buf_set_var(s:fnotebuf, 'fnote', v:true)
endfunction

function! s:open_win() abort
  let [width, height] = s:get_floatwin_size()
  let [row, col] = s:get_floatwin_pos(width, height)
  let opts = {
    \ 'relative': 'editor',
    \ 'anchor': 'NW',
    \ 'row': row,
    \ 'col': col,
    \ 'width': width,
    \ 'height': height,
    \ 'style':'minimal'
    \ }
  let winid = nvim_open_win(s:fnotebuf, v:false, opts)
  call s:nvim_win_set_option(winid)
  return winid
endfunction

function! s:resize_win(winid) abort
  let opts = nvim_win_get_config(a:winid)
  let [width, height] = s:get_floatwin_size()
  let opts.width = width
  let opts.height = height
  let opts.style = 'minimal'
  call nvim_win_set_config(a:winid, opts)
  call s:nvim_win_set_option(a:winid)
endfunction

function! s:nvim_win_set_option(winid) abort
  call nvim_win_set_option(a:winid, 'wrap', v:true)
  call nvim_win_set_option(a:winid, 'foldcolumn', 1)
endfunction

function! s:get_floatwin_size() abort
  let maxheight =
    \ g:fnote_window_maxheight ==# v:null
    \ ? float2nr(0.4*&lines)
    \ : float2nr(g:fnote_window_maxheight)
  let maxwidth =
    \ g:fnote_window_maxwidth ==# v:null
    \ ? float2nr(0.4*&columns)
    \ : float2nr(g:fnote_window_maxwidth)

  let width = 0
  let height = 0
  for line in getbufline(s:fnotebuf, 1, '$')
    let line_width = strdisplaywidth(line)
    if line_width > maxwidth
      let width = maxwidth
      let height += line_width / maxwidth + 1
    else
      let width = max([line_width, width])
      let height += 1
    endif
  endfor
  if height > maxheight
    let height = maxheight
  endif
  return [width+2, height]
endfunction

function! s:get_floatwin_pos(width, height) abort
  let curr_pos = getpos('.')
  let row = 1 " next to tabline
  let col = &columns - a:width
  return [row, col]
endfunction

function! s:winexists(winid) abort
  return len(getwininfo(a:winid)) > 0
endfunction

function! fnote#move_complete(...) abort
  return ['up', 'right', 'down', 'left']
endfunction

function! fnote#resize_complete(...) abort
  return ['x', 'y']
endfunction
