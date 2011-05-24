" checklist.vim - v0.3
" Vim script for managing a checklist.
" Last Modified: Tue 05/24/2011 03:09 PM
" Maintainer: Chris Truett <http://www.theywillknow.us>
" 
" Description:
" Checklist.vim is a super-simple way to manage .txt todo lists.
"
" Update:
" Rewrote the plugin from the ground up; now uses <leader>v and <leader>V to manage all changes to the checklist items. Timestamps are default.

" Only load plugin once
if exists("manage_checklist")
  finish
endif

let manage_checklist = 1
let g:checklist_use_timestamps = 1

function! MakeItem (type)
  let current_line = getline('.')
  if match(current_line,'\[_]') >= 0
    " If item is unchecked, check it and add timestamp
    echo "Item checked."
    exe 's/\[_]/[x]/'
    let time = strftime("%I:%M %p")
    if g:checklist_use_timestamps == 1
      exe "normal 0f]a ".time.":"
    endif
    return ""
  elseif match(current_line,'\[x]') >= 0
    " If line is already checked, uncheck it and remove timestamp
    echo "Item unchecked."
    if g:checklist_use_timestamps == 1
      exe 's/\[x] [0-9]*:[0-9]* [A|P]M:/[_]/i'
    elseif g:checklist_use_timestamps == 0
      exe 's/\[x]/[_]/i'
    endif
    return ""
  else
    " If line is empty, add a new item.
    " Check if this is a top-level or a sub-item
    if a:type == 'top'
      " If top level, place '[_] '
      exe "normal i[_] "
      return ""
    elseif a:type == 'sub'
      " If sub level, place '[_] ' and indent
      exe "normal i[_] "
      return ""
    endif
  endif
endfunction

nmap <leader>v  :call MakeItem('top')<CR>i<End>
nmap <leader>V  :call MakeItem('sub')<CR>V>i<End>

imap <leader>v  <C-R>=MakeItem('top')<CR><End>
imap <leader>V  <C-R>=MakeItem('sub')<CR><Esc>V>i<End>
