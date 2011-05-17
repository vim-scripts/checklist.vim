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
  put='[_] '
endfunction

function! s:makeSubItem()
  put='  [_] '
endfunction

function! s:checkItem()
  let current_line = getline('.')
  if match(current_line,"[_]") >= 0
    let time = strftime("%I:%M %p")
    exe "s/\[_\]/x/i"
    exe "normal A - ".time
    echo "Item checked."
  else
    if match(current_line,'[x]') >= 0
      exe "s/\[x\]/_/i"
      exe "s/ - [0-9]*\:[0-9]* [A|P]M//i"
      echo "Item unchecked."
    endif
  endif
endfunction

command MakeItem    :call    <SID>makeItem()
command MakeSubItem :call    <SID>makeSubItem()
command CheckItem   :call    <SID>checkItem()

nmap <leader>z  :MakeItem        <CR>i<End>
nmap <leader>zs :MakeSubItem     <CR>i<End>
nmap <leader>zz :CheckItem       <CR><End>
imap <leader>z  <Esc>:MakeItem   <CR>i<End>
imap <leader>zs <Esc>:MakeSubItem<CR>i<End>
imap <leader>zz <Esc>:CheckItem  <CR><End>
