" Vim script for managing a checklist.
" Last Modified: Sat 05/14/2011 09:54 PM
" Maintainer: Chris Truett <chris.truett@gmail.com>
" 
" Description:
" Checklist.vim is a super-simple way to manage .txt todo lists.
" 
" Example:
" 
" [x] Finish writing date stamp support for checklist.vim - 09:47 PM
" [ ] Post checklist.vim on vim.org
" 
" Installation:
" Put checklist.vim into your plugin directory and restart vim.

if exists("manage_checklist")
    finish
endif
let manage_checklist = 1
 
function! s:makeItem()
  put='[ ] '
endfunction

function! s:checkItem()
  let current_line = getline('.')
  if match(current_line,'\[\s\]')
    exe "s/\[x\]/ /i"
    exe "s/ - [0-9]*\:[0-9]* [A|P]M//i"
    echo "Item checked."
  else
    if match(current_line,'\[x\]')
      let time = strftime("%I:%M %p")
      exe "s/\[ \]/x/i"
      exe "normal A - ".time
      echo "Item unchecked."
    endif
  endif
endfunction

command MakeItem :call <SID>makeItem()
command CheckItem :call <SID>checkItem()

nmap <leader>z :MakeItem<CR>i<End>
imap <leader>z <Esc>:MakeItem<CR>i<End>
nmap <leader>zz :CheckItem<CR>
imap <leader>zz <Esc>:CheckItem<CR>
