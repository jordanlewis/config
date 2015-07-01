" .vimrc by Jordan Lewis
"
" Settings {{{
" General {{{
set autowrite          " Flush to disk when using :make and stuff
set autoread           " Reload safely if outside change detected
set backspace=indent,eol,start " Allow backspacing over everything
set confirm            " Confirm various potentially dangerous actions
set gdefault           " use s///g by default - s///gg to reverse
set hidden             " Enable hidden buffers - :bn w/ changes!
set magic              " Allows extended regexes
set nocompatible       " Don't use Vi settings!
set noerrorbells       " No annoying beeping
set nojoinspaces       " Don't put extra spaces on joining sentences.
set nostartofline      " Don't move to start of line on buffer next
set shell=/bin/bash    " zsh screws up
set ttimeoutlen=50     " 50 milliseconds for esc timeout instead of 1000
set ttyfast            " We are always going to be using a fast terminal.
call pathogen#infect()
filetype plugin indent on " File type detection on, (cindent for .c etc)
" }}}
" Appearance {{{
set background=light  " Dark term bg (but bg=dark is gross)
set display=lastline  " Display as much of the last line as possible, not @
set hlsearch          " Hilight /search results!
set incsearch         " do incremental searching
set list              " Display listchars (see below)
set listchars=tab:  ,trail:_ " display tabs as nbsps and trailing spaces as _
set matchtime=1       " 1/10 of a second for showmatch
set nomore            " No spacing through messages!
set nonumber          " Don't display line numbers on the side
set notitle           " Don't display name of file and stuff in term title
set report=0          " Show a 'N lines were changed' report always
set ruler             " Show current cursor position
set rulerformat=%25(%=%M%R\ (%n)%l,%c\ %P%)
set scrolloff=3       " Scroll screen at 3 lines from top/bottom

" o overwrite message for writing a file with subsequent message
" O message for reading a file overwrites any previous message.
" t truncate file message at the start if it is too long to fit. -> <
" T truncate other messages in the middle if they are too long. -> ...
" I don't give the intro message when starting Vim |:intro|.
set shortmess=aIoOTt  " a=terse(s/[modified]/[+]/),I=nointro,oO=:bn no message
" set showcmd         " display info on current selected visual field
set showmatch         " Hilight the other bracket
set showmode          " Show the current mode
set vb t_vb=          " Turns off all belly things
set wildchar=<TAB>    " Use tab as the tab key!
set wildmenu          " Display a tab-completion menu for most things
set wildignore+=*.pyc,*.zip,*.gz,*.tar,*.o,*.so " Don't open these files
syntax on             " Do syntax hilighting
" }}}
" Tabs and margins {{{
set tabstop=4     " Tab characters = 4 spaces when displayed
set shiftwidth=4  " Use 4 spaces for each insertion of (auto)indent
set expandtab     " <tab> -> spaces in insert mode
set autoindent    " always set autoindenting on
set smarttab      " Smart tabbing!
set shiftround    " < and > will hit indent levels instead of +-4 always
" set tw=80       " Make hard CR every 80 lines
" }}}
" Inter-session stuff {{{
" set viminfo='50,/50,:50,<50,n~/.viminfo
set history=100 " keep 100 lines of command line history
set nobackup    " Don't back up stuff. (makes nasty files~)
" }}}
" Folding {{{
set foldmethod=marker " Fold on 3 {, commenstring -> don't include " in title
"set foldclose=all    " Close folds when you leave them
"set foldenable       " All folds closed by default
" }}}
" Tags {{{
set tags+='./.tags,.tags' " add .tags files
set tags+='./../tags,../tags,./../.tags,../.tags' " look in the level above
"}}}
" Miscellaneous {{{
"set commentstring="%s 
set dict=/usr/share/dict/words
set tildeop           " Turn ~ into an operator
let g:EnhCommentifyBindInInsert = 'No' " No enhancedcommentify in insert mode
let g:EnhCommentifyRespectIndent = 'Yes' " indent where I want you to indent
set switchbuf=useopen " Jump to open window containing jump target if available
let g:syntastic_error_symbol='✗'    " Prettier gutter symbols for Syntastic.
let g:syntastic_warning_symbol='⚠'
let g:syntastic_mode_map = { 'mode': 'passive',
                            \ 'active_filetypes': [],
                            \ 'passive_filetypes': [] }
"}}}
" Persistent undo {{{
if exists("+undofile")
    set udf
    set undodir=~/.vimundo
endif
" }}}
" }}}
" Mappings {{{
" Map Q to format line
map Q gq

" Make space pagedown
nmap <Space> <C-D>

" F5 -> toggle :set paste
set pastetoggle=<f5>

" F11 -> spellcheck hilighting on
map <F11> :call <SID>spell()<CR>
imap <F11> <Esc>:call <SID>spell()<CR>

" F12 -> toggle :set number
map <F12> :set number!<CR>

nmap gu :silent GundoToggle<CR>

nnoremap ! :Clam<space>
vnoremap ! :ClamVisual<space>
let g:clam_autoreturn = 1

nmap <leader>c <Plug>CommentaryLine
xmap <leader>c <Plug>Commentary

let g:ctrlp_map = '<C-F>'

" Make ctrl-n and ctrl-p cycle through buffers in cmd mode
nnoremap <C-N> :bn<Enter>
nnoremap <C-P> :bp<Enter>

" Make ctrl-j and ctrl-k cycle through split windows in cmd mode
nnoremap <C-J> :wincmd w<Enter>
nnoremap <C-K> :wincmd W<Enter>

" Make ctrl-h and ctrl-l cycle through yank ring
let g:yankring_replace_n_pkey = '<C-H>'
let g:yankring_replace_n_nkey = '<C-L>'

" :w!! sudo-saves the current buffer
cmap w!! w !sudo tee % >/dev/null

vmap <C-c> y:call system("pbcopy", getreg("\""))<CR>

nmap `/ :nohl<CR>

" }}}
" Autocommands {{{
" Jump to last known cursor position on file edit {{{
au BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\   exe "normal g`\"" |
\ endif
" }}}
" Auto +x {{{
au BufWritePost *.sh silent !/bin/bash -c 'if [ -x % ]; then exit; else /bin/chmod +x %; fi'
au BufWritePost *.pl silent !/bin/bash -c 'if [ -x % ]; then exit; else /bin/chmod +x %; fi'
au BufWritePost *.py silent !/bin/bash -c 'if [ -x % ]; then exit; else /bin/chmod +x %; fi'
"}}}
" Language specific things (Thanks doy!) {{{
" Perl {{{
" :make does a syntax check
autocmd FileType perl setlocal makeprg=$VIMRUNTIME/tools/efm_perl.pl\ -c\ %\ $*
autocmd FileType perl setlocal errorformat=%f:%l:%m

" look up words in perldoc rather than man for K
autocmd FileType perl setlocal keywordprg=perldoc\ -f

" treat use lines as include lines (for tab completion, etc)
" XXX: it would be really sweet to make gf work with this, but unfortunately
" that checks the filename directly first, so things like 'use Moose' bring
" up the $LIB/Moose/ directory, since it exists, before evaluating includeexpr
autocmd FileType perl setlocal include=\\s*use\\s*
autocmd FileType perl setlocal includeexpr=substitute(v:fname,'::','/','g').'.pm'
autocmd FileType perl exe "setlocal path=" . system("perl -e 'print join \",\", @INC;'") . ",lib"
" }}}
" Python {{{
" look up words in python rather than man for K
autocmd FileType python setlocal keywordprg=pydoc
autocmd FileType python set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
autocmd FileType python set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
"autocmd FileType python set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
"autocmd FileType python so ~/.vim/python_fold.vim
" }}}
" Latex {{{
" :make converts to pdf
if strlen(system('which xpdf')) && strlen(expand('$DISPLAY'))
    autocmd FileType tex setlocal makeprg=(cd\ %:h\ &&\ pdflatex\ %:t\ &&\ xpdf\ $(echo\ %:t\ \\\|\ sed\ \'s/\\(\\.[^.]*\\)\\?$/.pdf/\'))
elseif strlen(system('which evince')) && strlen(expand('$DISPLAY'))
    autocmd FileType tex setlocal makeprg=(cd\ %:h\ &&\ pdflatex\ %:t\ &&\ evince\ $(echo\ %:t\ \\\|\ sed\ \'s/\\(\\.[^.]*\\)\\?$/.pdf/\'))
else
    autocmd FileType tex setlocal makeprg=(cd\ %:h\ &&\ pdflatex\ %:t)
endif
" see :help errorformat-LaTeX
autocmd FileType tex setlocal errorformat=
    \%E!\ LaTeX\ %trror:\ %m,
    \%E!\ %m,
    \%+WLaTeX\ %.%#Warning:\ %.%#line\ %l%.%#,
    \%+W%.%#\ at\ lines\ %l--%*\\d,
    \%WLaTeX\ %.%#Warning:\ %m,
    \%Cl.%l\ %m,
    \%+C\ \ %m.,
    \%+C%.%#-%.%#,
    \%+C%.%#[]%.%#,
    \%+C[]%.%#,
    \%+C%.%#%[{}\\]%.%#,
    \%+C<%.%#>%.%#,
    \%C\ \ %m,
    \%-GSee\ the\ LaTeX%m,
    \%-GType\ \ H\ <return>%m,
    \%-G\ ...%.%#,
    \%-G%.%#\ (C)\ %.%#,
    \%-G(see\ the\ transcript%.%#),
    \%-G\\s%#,
    \%+O(%f)%r,
    \%+P(%f%r,
    \%+P\ %\\=(%f%r,
    \%+P%*[^()](%f%r,
    \%+P[%\\d%[^()]%#(%f%r,
    \%+Q)%r,
    \%+Q%*[^()])%r,
    \%+Q[%\\d%*[^()])%r
" }}}
" Lua {{{
" :make does a syntax check
autocmd FileType lua setlocal makeprg=luac\ -p\ %
autocmd FileType lua setlocal errorformat=luac:\ %f:%l:\ %m

" set commentstring
autocmd FileType lua setlocal commentstring=--%s

" treat require lines as include lines (for tab completion, etc)
autocmd FileType lua setlocal include=\\s*require\\s*
autocmd FileType lua setlocal includeexpr=substitute(v:fname,'\\.','/','g').'.lua'
autocmd FileType lua exe "setlocal path=" . system("lua -e 'local fpath = \"\" for path in package.path:gmatch(\"[^;]*\") do if path:match(\"\?\.lua$\") then fpath = fpath .. path:gsub(\"\?\.lua$\", \"\") .. \",\" end end print(fpath:gsub(\",,\", \",.,\"):sub(0, -2))'")
" }}}
" Vim {{{
autocmd FileType {vim,help} setlocal keywordprg=:help
" }}}
" Java {{{
au Filetype java setlocal omnifunc=javacomplete#Complete
" }}}
" OCaml {{{
autocmd FileType ocaml source /Users/jordan/.opam/4.01.0/share/vim/syntax/ocp-indent.vim
" }}}
" Use levdes syntax for .des files {{{
au BufRead,BufNewFile *.des set syntax=levdes
au BufRead,BufNewFile *.frag,*.vert,*.fp,*.vp,*.glsl set syntax=glsl
" }}}
" Don't expand tabs in Go files {{{
au BufRead,BufNewFile *.go set noexpandtab
" }}}

" }}}
" }}}
" Colors {{{
"autocmd BufWinEnter * syn match EOLWS excludenl /[ \t]\+$/
"highlight EOLWS      ctermbg=red
"highlight Pmenu      ctermfg=grey ctermbg=darkblue
"highlight PmenuSel   ctermfg=red  ctermbg=darkblue
"highlight PmenuSbar  ctermbg=cyan
"highlight PmenuThumb ctermfg=red
"highlight Folded     ctermbg=black ctermfg=darkgreen
"highlight Search     None          ctermfg=lightred

let g:vimclojure#HighlightBuiltins = 1
let g:vimclojure#HighlightContrib = 1
let g:vimclojure#DynamicHighlighting = 1
let g:vimclojure#FuzzyIndent = 1
let g:vimclojure#ParenRainbow = 1
let g:vimclojure#WantNailgun = 1
let g:vimclojure#NailgunClient = "/usr/local/bin/ng"
let g:solarized_visibility="normal"
let g:solarized_underline=0
"let g:solarized_termcolors=256
set bg=dark
colorscheme solarized

let python_hilight_all=1

" Rainbowy parens, braces, and brackets thanks to Eidolos{{{
let g:rainbow         = 1 " Must be a more compact way of setting all these
let g:rainbow_nested  = 1
let g:rainbow_paren   = 1
let g:rainbow_brace   = 1
let g:rainbow_bracket = 1
autocmd BufReadPost,BufNewFile *.ss source $HOME/.vim/scripts/rainbow_paren.vim
autocmd BufReadPost,BufNewFile *.scm source $HOME/.vim/scripts/rainbow_paren.vim
"}}}

" }}}
" Functions {{{
" Add spelling stuff, invoke by f11 {{{
function s:spell()
    if !exists("s:spell_check") || s:spell_check == 0
        echo "Spell check on"
        let s:spell_check = 1
        setlocal spell spelllang=en_us
    else
        echo "Spell check off"
        let s:spell_check = 0
        setlocal spell spelllang=
    endif
endfunction " }}}
" diff between current file and its original state {{{
let s:foldmethod = &foldmethod
let s:foldenable = &foldenable
function s:diffstart(read_cmd)
    let s:foldmethod = &foldmethod
    let s:foldenable = &foldenable
    vert new
    set bt=nofile
    try
        exe a:read_cmd
    catch /.*/
        echoerr v:exception
        call s:diffstop()
        return
    endtry
    diffthis
    wincmd p
    diffthis
endfunction
function s:diffstop()
    diffoff!
    if winnr('$') != 1
        wincmd t
        quit
    endif
    let &foldmethod = s:foldmethod
    let &foldenable = s:foldenable
endfunction
function s:vcs_orig(file)
    if filewritable('.svn')
        return system('svn cat ' . a:file)
    elseif filewritable('CVS')
        return system("AFILE=" . a:file . "; MODFILE=`tempfile`; DIFF=`tempfile`; cp $AFILE $MODFILE && cvs diff -u $AFILE > $DIFF; patch -R $MODFILE $DIFF 2>&1 > /dev/null && cat $MODFILE; rm $MODFILE $DIFF")
    elseif finddir('_darcs', '.;') =~ '_darcs'
        return system('darcs show contents ' . a:file)
    elseif finddir('.git', '.;') =~ '.git'
        return system('git show ' . a:file)
    else
        throw 'No vcs found'
    endif
endfunction
nmap <silent> ds :call <SID>diffstart('read # <bar> normal ggdd')<CR>
nmap <silent> dc :call <SID>diffstart('call append(0, split(s:vcs_orig(expand("#")), "\n", 1)) <bar> normal Gdddd')<CR>
nmap <silent> de :call <SID>diffstop()<CR>
" }}}
" SuperTab {{{
let g:SuperTabMidWordCompletion = 0
let g:SuperTabDefaultCompletionType = 'context'
" }}}
" }}}

" vim:fdm=marker commentstring="%s
