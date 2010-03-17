"  darcs.vim: (global plugin) Darcs-related commands in vim
"  Maintainer:  sylvain.joyeux@m4x.org
"  Version:     0.2 for vim 7.0+
"  URL:		http://www.vim.org/script.php?script_id=1683
"
" Documentation:
"  Defines the following commands: 
"    DarcsDiff  shows the diff between the file in the current buffer and the
"		Darcs version of that file 
"    DarcsOff   closes the diff view opened by DarcsDiff 
"    DarcsChanges shows the changes to the file in the current buffer. 

if exists("loaded_darcs")
    finish
endif
let loaded_darcs=1

" Find the directory containing 'test_file'. test_file
" can be either a file (test_kind == 'file') or a directory
" (test_kind == 'dir')
function s:FindDir(test_file, test_kind)
    let test_with = {'dir': 'isdirectory', 'file': 'filereadable'}
    let test_function = test_with[a:test_kind]

    let curdir = expand("%:p:h")
    let basedir = curdir
    while curdir != "/" && !call(test_function, [curdir . "/" . a:test_file])
	let curdir = fnamemodify(curdir, ':h')
    endwhile

    if curdir == '/'
        echoerr "cannot find the " . a:test_kind . " " . a:test_file . " from " . basedir
    elseif curdir !~ '/$'
        return curdir . '/'
    else
        return curdir
    endif
endfunction

function s:DarcsRoot()
    let basedir = s:FindDir('_darcs', 'dir')
    if basedir =~ '^$'
	throw "this is not a Darcs repository"
    endif
    return basedir
endfunction

function s:DarcsPristine()
    let root = s:DarcsRoot() . '/_darcs/'
    if isdirectory(root . 'pristine')
	return root . 'pristine'
    elseif isdirectory(root . 'current')
	return root . 'current'
    else
	echoerr 'cannot determine darcs pristine directory in ' . root
    endif
endfunction

function s:DarcsDiff()
    let root = s:DarcsRoot()
    " this filename path w.r.t. darcs root
    let filename = substitute(expand("%:p"), root, '', "")

    " the filename in the pristine
    let pristine = s:DarcsPristine() . '/' . filename
    if filereadable(pristine)
	let g:darcs_diff = [pristine, expand("%")]
	execute ":diffsplit " . pristine
	setlocal buftype=nowrite
	setlocal bufhidden=delete
	setlocal noswapfile
	setlocal ro
    endif
endfunction
function s:EnsureVisible(bufname)
    let win_nr = bufwinnr("\\[" . a:bufname . "\\]")
    if win_nr == -1
	execute "sbuf " bufnr("\\[" . a:bufname . "\\]")
    else
	execute win_nr . "wincmd w"
    endif
endfunction

function s:DarcsChanges(...)
    let root = s:DarcsRoot()
    " root ends with '/' remove it first with :h and then get the tail
    let cmd = ".! darcs changes " . join(a:000, ' ') . expand('%')

    let bufname = "Changes for " . fnamemodify(root, ":h:t")
    if bufexists("[" . bufname . "]")
	call s:EnsureVisible(bufname)
    else
	execute "new " . "[" . bufname . "]"
    endif
    setlocal buftype=nowrite
    setlocal bufhidden=delete
    setlocal noswapfile
    execute cmd
endfunction

function s:DarcsOff()
    if exists("g:darcs_diff")
	let [pristine, orig] = g:darcs_diff
	unlet g:darcs_diff

	" Delete the pristine file buffer
	execute ":bdelete " . pristine
	" Remove diff mode on the original window if it
	" is visible
	let win_nr = bufwinnr(orig)
	if win_nr != -1
	    execute win_nr . "wincmd w"
	    diffoff
	endif
    endif
endfunction

command DarcsDiff :call s:DarcsDiff()
command DarcsOff :call s:DarcsOff()
command -nargs=* DarcsChanges :call s:DarcsChanges(<f-args>)

