" Title: checklist.vim - v0.6
" Summary: Vim script for creating a checklist.
" Last Modified: Sat 05/28/2011 05:51 AM
" Maintainer: Chris Truett <http://www.theywillknow.us>
" Description: Checklist.vim is a super-simple way to create todo lists.

" Only load plugin once
if exists("manage_checklist")
  "finish
endif

if g:checklist_use_timestamps == 0
  let g:checklist_use_timestamps = 0
else
  let g:checklist_use_timestamps = 1
endif

"let manage_checklist = 1

function! MakeItem ()
  " Define variables
  let l:line = getline(line(".") - 1)

  " Check what the previous line contains
  function! CheckPrevLine ()
    let l:line = getline(line(".") - 1)
    if match(l:line, '^\s*$') >= 0
      return "Empty"
    else
      return "Not Empty"
    endif
  endfunction

  " Add checkboxes or parent items
  if CheckPrevLine() == 'Empty'
    exe 'normal ddo+ '
    return ''
  elseif match(l:line, '\V+ ') >= 0
    exe 'normal i* '
    exe 'normal v>'
    return ''
  elseif match(l:line, '\V* ') >= 0
    exe 'normal i* '
    return ''
  elseif match(l:line, '\V× ') >= 0
    exe 'normal i* '
    return ''
  else
    return ''
  endif
endfunction

function! ToggleItem ()
  " Define variables
  let current_line = getline('.')
  let l:line = getline(line(".") - 1)

  " Toggle checkboxes and timestamps
  if match(current_line,'\V* ') >= 0
    echo "Item checked."
    exe 's/\V* /× /'
    let time = strftime("%d.%m.%Y at %I:%M %p")
    if g:checklist_use_timestamps == 1
      exe "normal a ".time." :"
    endif
    return ""
  elseif match(current_line,'\V× ') >= 0
    echo "Item unchecked."
    if g:checklist_use_timestamps == 1
      exe 's/\× \d\{2}\.\d\{2}\.\d\{4} at \d\{2}:\d\{2} [A|P]M :/*/i'
    elseif g:checklist_use_timestamps == 0
      exe 's/\V× /* /i'
    endif
    return ""
  endif

  " Toggle Folds
  if match(current_line,'^+ ') >= 0
    exe 'normal jzc'
    exe 'normal k'
    exe 's/\V+ /- /i'
    return ""
  elseif match(current_line,'^- ') >= 0
    exe 'normal jzo'
    exe 'normal k'
    exe 's/\V- /+ /i'
    return ""
  endif
endfunction

" Checkbox
imap <leader>v  <C-R>=MakeItem()<CR><End>
nmap <leader>v  :call MakeItem()<CR>i<End>

" Toggle
nmap <leader>vv :call ToggleItem()<CR><End>
