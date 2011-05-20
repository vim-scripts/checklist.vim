" checklist.vim - v0.3
" Vim script for managing a checklist.
" Last Modified: Thu 05/19/2011 11:07 PM
" Maintainer: Chris Truett <http://www.theywillknow.us>
" 
" Description:
" Checklist.vim is a super-simple way to manage .txt todo lists.
" 
" Example:
" [x] Finish writing date stamp support for checklist.vim - 09:47 PM
" [ ] Post checklist.vim on vim.org
" 
" Installation:
" Put checklist.vim into your plugin directory and restart vim.

" Only load plugin once
if exists("manage_checklist")
  finish
endif
let manage_checklist = 1

" Make initial list item
function s:makeItem(type)
  let type = a:type
  echo type
  if type == 'sub'
    put='  [_] '
  endif
  if type == 'normal'
    put='[_] '
  endif
endfunction

" Toggle checkmark and timestamp
function! s:checkItem (stamp)
  let current_line = getline('.')
  if match(current_line,"[_]") >= 0
    let time = strftime("%I:%M %p")
    exe "s/\[_\]/x/i"
    if a:stamp == "stamped"
      exe "normal A - ".time
    endif
    echo "Item checked."
  else
    let datestring = ' - [0-9]*\:[0-9]* [A|P]M'
    if match(current_line,'[x]') >= 0
      exe "s/\[x\]/_/i"
      if match(current_line, datestring) >= 0
        exe "s/ - [0-9]*\:[0-9]* [A|P]M//i"
      endif
      echo "Item unchecked."
    endif
  endif
endfunction

" Make Commands
command MakeItem         :call <SID>makeItem('normal')
command MakeSubItem      :call <SID>makeItem("sub")
command CheckItem        :call <SID>checkItem("")
command CheckItemStamped :call <SID>checkItem("stamped")

" Normal mode mapping
nmap <leader>z  :MakeItem        <CR>i<End>
nmap <leader>zs :MakeSubItem     <CR>i<End>
nmap <leader>zz :CheckItem       <CR><End>
nmap <leader>zt :CheckItemStamped       <CR><End>

" Insert mode mapping
imap <leader>z  <Esc>:MakeItem   <CR>i<End>
imap <leader>zs <Esc>:MakeSubItem<CR>i<End>
imap <leader>zz <Esc>:CheckItem  <CR><End>
imap <leader>zt <Esc>:CheckItemStamped  <CR><End>
