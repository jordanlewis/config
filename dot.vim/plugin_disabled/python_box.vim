" Vim plugin for the Python programming language
" FILE: python_box.vim
" LAST MODIFICATION: 2003 Feb 1
" Maintainer: Christoph Herzog <ccf.herzog@gmx.net>
" Version: 0.5
"
" Parts of this script (as indicated in the code) were taken from python.vim,
" copyright 2001 Mikael Berthe <mikael.berthe@efrei.fr>.
" 
" This script needs the python compilerscript python.vim as well as 
" python_match.vim by Benji Fisher.
"
"---------------------------------------------------------------------------
"----Some hints on how to use
"---------------------------------------------------------------------------
" The buffer TOC offers a outline of all Python classes and functions of the
" current buffer in a seperate vim window. The cursor position in the TOC window
" indicates where you are in the original Window containing the Python code. 
" Press <F5> again (or q) to quit that window without changing the cursor 
" position in the original window (containing the Python code).
" That I find practical when editing a Python file and getting confused 
" about where I am.
" If you want to change your position in the Python file:
" Set the cursor in the TOC window to the class/function you want to jump to 
" then press <RETURN> to go there.
" If the TOC windows is split pressing <SPACE> will navigate to the
" class/function but the TOC window will remain open and will keep the focus.
" Doubleclicking the left mousebutton will have the same effect.
" However if the window is not split left doublclicking or pressing <SPACE>
" will have the same effect as pressing <RETURN>.
" Once the TOC-window looses its focus it is closed immediately so to be out of
" the way.


if exists("b:did_python_box")
  finish
endif
let b:did_python_box = 1

"---------------------------------------------------------------------------
"----user definable mappings and variables:
"---------------------------------------------------------------------------


"***************KEY-MAPPINGS FOR PYTHON-BOX*******************
"
"if you change them, remember to change them in the Menus also
"Check Syntax
noremap <buffer><A-1> :call CheckPythonSyntax()<CR>:cl<CR>
"Execute current file
noremap <A-F5> :make %<CR><CR>:clast<CR>:cl<CR>
"Key to call outline window in nosplit mode:
map <F5> :call StartOutline("nosplit")<RETURN>
"Key to call outline window in horizontal split mode:
map <S-F5> :call StartOutline("horizontal")<RETURN>
"Key to call outline window in vertical split mode:
map <C-F5> :call StartOutline("vertical")<RETURN>
"Keys to select class:
map <silent>vc :call PythonSelectObject("class")<CR>
"Keys to select function:
map <silent>vd :call PythonSelectObject("function")<CR>
"Keys to go to previous class:
map <silent>[c :call PythonDec("class", -1)<CR>
"Keys to go to next class:
map <silent>]c :call PythonDec("class", 1)<CR>
"Keys to go to previous function:
map <silent>gk :call PythonDec("function", -1)<CR>
"Keys to go to next function:
map <silent>gj :call PythonDec("function", 1)<CR>


"Keys for the outline buffer:
function! DefineOutlineNavigationMaps()
	"go to target, close outline buffer:
	map <silent><buffer> <CR> :call NavigateToOutlineTag(0)<CR>
	"view target, keep outline buffer (only when in split mode):
	map <silent><buffer> <SPACE> :call NavigateToOutlineTag(1)<CR>
	"quit outline buffer:
	map <silent><buffer> q :call QuitOutlineBuffer()<CR>
	"left double click: goto target, close outline buffer:
	nnoremap <buffer> <2-leftmouse> :call <SID>LeftDoubleClick()<cr>
endfunction


"***************MENU DEFINITIONS FOR PYTHON-BOX****************
"the next two functions require the Python compiler plugin and
"the command "compiler python"
nmenu <silent>&PythonBox.Check\ Syntax<Tab>Alt-1 <A-1>
nmenu <silent>&PythonBox.Run\ current\ File<Tab>Alt-F5 <A-F5>
nmenu &PythonBox.-Sep0- :
"this requires having sourced buftoc.vim:
nmenu <silent> &PythonBox.Buffer\ TOC<Tab>F5 :call StartOutline("nosplit")<CR>
nmenu <silent> &PythonBox.Buffer\ TOC\ (split)<Tab>Shift-F5  :call StartOutline("horizontal")<CR>
nmenu <silent> &PythonBox.Buffer\ TOC\ (vsplit)<Tab>Ctrl-F5 :call StartOutline("vertical")<CR>
nmenu &PythonBox.-Sep1- :
nmenu <silent> &PythonBox.Comment\ Selection :call PythonCommentSelection()<CR>
vmenu <silent> &PythonBox.Comment\ Selection :call PythonCommentSelection()<CR>
nmenu <silent> &PythonBox.Uncomment\ Selection :call PythonUncommentSelection()<CR>
vmenu <silent> &PythonBox.Uncomment\ Selection :call PythonUncommentSelection()<CR>
nmenu &PythonBox.-Sep2- :
nmenu <silent> &PythonBox.Previous\ Class<Tab>[c :call PythonDec("class", -1)<CR>
nmenu <silent> &PythonBox.Next\ Class<Tab>]c     :call PythonDec("class", 1)<CR>
nmenu <silent> &PythonBox.Previous\ Function<Tab>gk :call PythonDec("function", -1)<CR>
nmenu <silent> &PythonBox.Next\ Function<Tab>gj     :call PythonDec("function", 1)<CR>
nmenu &PythonBox.-Sep3- :
nmenu <silent> &PythonBox.Select\ Function<Tab>vd :call PythonSelectObject("function")<CR>
nmenu <silent> &PythonBox.Select\ Class<Tab>vc    :call PythonSelectObject("class")<CR>
nmenu &PythonBox.-Sep4- :
"The following menus refer to python_match.vim by Benji Fisher:
nmenu <silent> &PythonBox.Toggle\ Block<Tab>% %
vmenu <silent> &PythonBox.Toggle\ Block<Tab>% %
nmenu <silent> &PythonBox.Toggle\ Block\ back<Tab>g% g%
vmenu <silent> &PythonBox.Toggle\ Block\ back<Tab>g% g%
nmenu <silent> &PythonBox.Start\ Block<Tab>[% [%
vmenu <silent> &PythonBox.Start\ Block<Tab>[% [%
nmenu <silent> &PythonBox.End\ Block<Tab>]% ]%
vmenu <silent> &PythonBox.End\ Block<Tab>]% [%

"---------------------------------------------------------------------------
"----no editing should be necessary beyond this point
"---------------------------------------------------------------------------

"use python compiler plugin
compiler python

"this requires Python compiler plugin
function! CheckPythonSyntax()
  let curfile = bufname("%")
  exec ":make " . "-c " . "\"import py_compile; py_compile.compile(r'" . bufname("%") . "')\""
endfunction

"this is for the buffer TOC:
let g:outlineLinePairList	= ""		    "format: #12:345
let g:outlineBufferNumber	= -1			"keep for receycling
let g:outlineWinSplitMode	= "nosplit"		"default
let g:outlinedBufferName  	= ""			"set by function StartOutline
let g:outlinedBufferFType 	= ""			"set by function StartOutline
let g:CursorPositionInTOC   = 0             "set by function s:SetOutline
let g:outlineTempHidden     = 0             "hack to avoid problems with splitting

"Start Outline
function! StartOutline(splitmode)
	"don't apply outline to itself:
	if bufnr("%") == g:outlineBufferNumber
		echo "Can't outline toc!"
        call QuitOutlineBuffer()
		return
	endif
	"set gobal variables:
    let g:CursorPositionInTOC = 0
	let g:outlineWinSplitMode = a:splitmode
	let g:outlinedBufferName = bufname("%")
	let g:outlinedBufferFType = &filetype
	let ft = g:outlinedBufferFType
	if ft == "python"
		let regexp = "\\m\\C\^\\s*class\\s\\+[a-zA-Z0-9_]\\+\\\|\^\\s*def\\s\\+[a-zA-Z0-9_]\\+"
		call s:SetOutline(regexp, "#")
	else
		echo ft "is not implemented"
		return
	endif
endfunction


"This immediately closes buffer, when changing to other window
autocmd WinLeave * call CloseOutline()
autocmd BufHidden * call CloseOutline()
function! CloseOutline()
	if bufwinnr(g:outlineBufferNumber) != -1 && bufnr("%") == g:outlineBufferNumber && g:outlineTempHidden == 0
      let g:outlineBufferNumber = -1
	  bw   
	endif
endfunction


"close Outline buffer, set buffer number to -1:
function! QuitOutlineBuffer()
	let g:outlineBufferNumber = -1
    bw
endfunction


"creates an outlinewindow
function! MakeOutlineWindow(outlinelist)
	"is_split can be: "nosplit", "horizontal", "vertical"
	let is_split = g:outlineWinSplitMode
	"look for existing buffer:
	let oldbuffer = g:outlineBufferNumber
	if oldbuffer == -1
		if is_split == "nosplit"
			exec ":enew"
		elseif is_split == "horizontal"
			exec ":new"
		elseif is_split == "vertical"
			exec ":vnew"
		else
			"treat as nosplit"
			is_split = "nosplit"
			exec ":enew"
		endif
		let g:outlineBufferNumber = bufnr("%")
	else
		if is_split == "nosplit"
			exec ":buffer " . oldbuffer
		elseif is_split == "horizontal"
			exec ":split "
			exec ":buffer " . oldbuffer
		elseif is_split == "vertical"
			exec ":vsplit "
			exec ":buffer " . oldbuffer
		else
			exec ":buffer " . oldbuffer
		endif
		"to insert outlinelist:
		setlocal modifiable
		setlocal noswapfile
		setlocal buftype=nowrite
        setlocal bufhidden=delete
		setlocal nowrap
		"empty buffer:
		normal gg
		normal dG
	endif
	setlocal noautoindent nocindent nosmartindent
	exec "normal i" . a:outlinelist
	setlocal nomodifiable
	setlocal nomodified
    exec "normal " . g:CursorPositionInTOC . "G"
	call DefineOutlineNavigationMaps()
    "some highlighting
    if has("syntax") && exists("g:syntax_on") && !has("syntax_items")
      syn keyword pyStatement	def class nextgroup=pyFunction skipwhite
      syn match   pyFunction	"[a-zA-Z_][a-zA-Z0-9_]*" contained
      syn match   pyComment	    "#.*$"

      hi def link pyComment       Comment
      hi def link pyFunction      Function
      hi def link pyStatement     Statement
    endif
endfunction

function! NavigateToOutlineTag(navmode)
	"navmode may be:
	"0 = go to target, close outline
	"1 = view target, keep outline (cursor in outline)
	let myline = line(".")
	let mybuffer = g:outlinedBufferName
	if !bufexists(mybuffer)
		echoerr mybuffer . " does not exist!"
		return
	endif
	"find line pair in g:outlineLinePairList corresponding to myline
	let lnpair = matchstr(g:outlineLinePairList, "#".myline.":"."[0-9]\\+")
	let targetline = matchstr(lnpair, "[0-9]\\+$")
	"arrange buffers/windows, go to targetline
	let is_split = g:outlineWinSplitMode
	if a:navmode     == 0 && is_split == "nosplit"
        call QuitOutlineBuffer()
		exec ":b " . mybuffer
		exec ":". targetline
		normal zt
	elseif a:navmode == 0 && is_split == "horizontal"
        call QuitOutlineBuffer()
		exec ":b " . mybuffer
		exec ":". targetline
		normal zt
	elseif a:navmode == 0 && is_split == "vertical"
        call QuitOutlineBuffer()	
		exec ":b " . mybuffer
		exec ":". targetline
		normal zt
	elseif a:navmode == 1 && is_split == "nosplit"
        call QuitOutlineBuffer()
		exec ":b " . mybuffer
		exec ":". targetline		
		normal zt
	elseif a:navmode == 1 && is_split == "horizontal"
        let g:outlineTempHidden = 1
        hide
		exec ":b " . mybuffer
		exec ":". targetline
		normal zt
		split
		exec ":b " . g:outlineBufferNumber
        let g:outlineTempHidden = 0
	elseif a:navmode == 1 && is_split == "vertical"
        let g:outlineTempHidden = 1      
		hide
        exec ":b " . mybuffer
		exec ":". targetline
		normal zt
		vsplit
		exec ":b " . g:outlineBufferNumber
        let g:outlineTempHidden = 0
	endif
endfunction

function! s:LeftDoubleClick()
 call NavigateToOutlineTag(1)
endfunction

function! s:SetOutline(regexp, comchars)
	let mypattern = a:regexp
	"store line and column:
	let myline = line(".")
	let mycol  = col(".")
	"go to start of buffer:
	normal gg
	"The first line should not be used for a tag, because
	"it is only found after wrapping search even when cursor is at 
	"beginning of file:
	let mylist = a:comchars . g:outlinedBufferName . "\n"
	let lnlist = "#1:1" . "\n"
	let lcount = 1
	let a = search(mypattern, "W")
	if a > 0
		let mylist = mylist . matchstr(getline(a), mypattern)
        "know function where cursor currently is:
        if line(".") > myline && g:CursorPositionInTOC == 0
          let g:CursorPositionInTOC = lcount
        endif
		let lcount = lcount + 1          
		let lnlist = lnlist . "#" . lcount . ":" . line(".")
	endif
	while a > 0
		let a = search(mypattern, "W")
		if a > 0
			let mylist = mylist . "\n" . matchstr(getline(a), mypattern)
            "know function where cursor currently is:
            if line(".") > myline && g:CursorPositionInTOC == 0
              let g:CursorPositionInTOC = lcount
            endif
			let lcount = lcount + 1
			let lnlist = lnlist . "\n" . "#" . lcount . ":" . line(".")
		endif
	endwhile
    if g:CursorPositionInTOC == 0
      g:CursorPositionInTOC = lcount
    endif
	let g:outlineLinePairList = lnlist
	"go to stored line and column:
	execute ":" . myline
	execute "normal " . mycol . "\|"
	call MakeOutlineWindow(mylist)	
endfunction


"---------------------------------------------------------------------------
"----This part is by Mikael Berthe
"---------------------------------------------------------------------------

" Go to previous (-1) or next (1) class/function definition
function! PythonDec(obj, direction)
  if (a:obj == "class")
    let objregexp = "^\\s*class\\s\\+[a-zA-Z0-9_]\\+"
        \ . "\\s*\\((\\([a-zA-Z0-9_,. \\t\\n]\\)*)\\)\\=\\s*:"
  else
    let objregexp = "^\\s*def\\s\\+[a-zA-Z0-9_]\\+\\s*(\\_[^:#]*)\\s*:"
  endif
  let flag = "W"
  if (a:direction == -1)
    let flag = flag."b"
  endif
  let res = search(objregexp, flag)
endfunction


" Comment out selected lines
" commentString is inserted in non-empty lines, and should be aligned with
" the block
function! PythonCommentSelection()  range
  let commentString = "#"
  let cl = a:firstline
  let ind = 1000    " I hope nobody use so long lines! :)

  " Look for smallest indent
  while (cl <= a:lastline)
    if strlen(getline(cl))
      let cind = indent(cl)
      let ind = ((ind < cind) ? ind : cind)
    endif
    let cl = cl + 1
  endwhile
  if (ind == 1000)
    let ind = 1
  else
    let ind = ind + 1
  endif

  let cl = a:firstline
  execute ":".cl
  " Insert commentString in each non-empty line, in column ind
  while (cl <= a:lastline)
    if strlen(getline(cl))
      execute "normal ".ind."|i".commentString
    endif
    execute "normal j"
    let cl = cl + 1
  endwhile
endfunction

" Uncomment selected lines
function! PythonUncommentSelection()  range
  " commentString could be different than the one from CommentSelection()
  " For example, this could be "# \\="
  let commentString = "#"
  let cl = a:firstline
  while (cl <= a:lastline)
    let ul = substitute(getline(cl),
             \"\\(\\s*\\)".commentString."\\(.*\\)$", "\\1\\2", "")
    call setline(cl, ul)
    let cl = cl + 1
  endwhile
endfunction

" Select an object ("class"/"function")
function! PythonSelectObject(obj)
  " Go to the object declaration
  normal $
  call PythonDec(a:obj, -1)
  let beg = line('.')

  if !exists("g:py_select_leading_comments") || (g:py_select_leading_comments)
    let decind = indent(beg)
    let cl = beg
    while (cl>1)
      let cl = cl - 1
      if (indent(cl) == decind) && (getline(cl)[decind] == "#")
        let beg = cl
      else
        break
      endif
    endwhile
  endif

  if (a:obj == "class")
    let eod = "\\(^\\s*class\\s\\+[a-zA-Z0-9_]\\+\\s*"
            \ . "\\((\\([a-zA-Z0-9_,. \\t\\n]\\)*)\\)\\=\\s*\\)\\@<=:"
  else
   let eod = "\\(^\\s*def\\s\\+[a-zA-Z0-9_]\\+\\s*(\\_[^:#]*)\\s*\\)\\@<=:"
  endif
  " Look for the end of the declaration (not always the same line!)
  call search(eod, "")

  " Is it a one-line definition?
  if match(getline('.'), "^\\s*\\(#.*\\)\\=$", col('.')) == -1
    let cl = line('.')
    execute ":".beg
    execute "normal V".cl."G"
  else
    " Select the whole block
    normal j
    let cl = line('.')
    execute ":".beg
    execute "normal V".PythonBoB(cl, 1, 0)."G"
  endif
endfunction

" Go to a block boundary (-1: previous, 1: next)
" If force_sel_comments is true, 'g:py_select_trailing_comments' is ignored
function! PythonBoB(line, direction, force_sel_comments)
  let ln = a:line
  let ind = indent(ln)
  let mark = ln
  let indent_valid = strlen(getline(ln))
  let ln = ln + a:direction
  if (a:direction == 1) && (!a:force_sel_comments) && 
      \ exists("g:py_select_trailing_comments") && 
      \ (!g:py_select_trailing_comments)
    let sel_comments = 0
  else
    let sel_comments = 1
  endif

  while((ln >= 1) && (ln <= line('$')))
    if  (sel_comments) || (match(getline(ln), "^\\s*#") == -1)
      if (!indent_valid)
        let indent_valid = strlen(getline(ln))
        let ind = indent(ln)
        let mark = ln
      else
        if (strlen(getline(ln)))
          if (indent(ln) < ind)
            break
          endif
          let mark = ln
        endif
      endif
    endif
    let ln = ln + a:direction
  endwhile

  return mark
endfunction

"---------------------------------------------------------------------------
"----End of the code taken from Mikael Berthe
"---------------------------------------------------------------------------
"
"
" vim:set et sts=2 sw=2:




