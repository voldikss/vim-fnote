# vim-fnote

[![Build Status](https://travis-ci.org/voldikss/vim-fnote.svg?branch=master)](https://travis-ci.org/voldikss/vim-fnote)

Temporary note taking plugin for NeoVim



## Installation

```vim
Plug 'voldikss/vim-fnote'
```

## Features

- Floating window support

- Allow to toggle/move/resize note window

## Configuration

#### **`g:fnote_window_width`**

- Default: `30`

#### **`g:fnote_window_height`**

- Default: `5`

## Key Mappings

This plugin doesn't supply any default mappings.

## Commands

#### `:FNoteNew`

Open a new floating window that displays the text in register `"`

#### `:FNoteToggle`

Toggle it

#### `:FNoteMove {direction} {interval}`

Move the window along `{direction}` by size `{interval}`

#### `:FNoteResize {dimension} {interval}`

Increase or decrease the note window by `{interval}`

**Configuration Example**:

```vim
nnoremap <silent> <Leader>fn :FNoteNew<CR>
nnoremap <silent> <Leader>ft :FNoteToggle<CR>
nnoremap <silent> <C-up>     :FNoteMove y 1<CR>    " move up by 1
nnoremap <silent> <C-down>   :FNoteMove y -1<CR>   " move down by 1
nnoremap <silent> <C-right>  :FNoteMove x 5<CR>    " move right by 5
nnoremap <silent> <C-left>   :FNoteMove x -5<CR>   " move left by 5
nnoremap <silent> <M-up>     :FNoteResize y 1<CR>  " increase window height by 1
nnoremap <silent> <M-down>   :FNoteResize y -1<CR> " decrease window height by 1
nnoremap <silent> <M-right>  :FNoteResize x 1<CR>  " increase window width by 1
nnoremap <silent> <M-left>   :FNoteResize x -1<CR> " decrease window width by 1
```

### License

MIT
