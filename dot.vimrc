" toft's .vimrc
" For Great Justice!
" Settings {{{
" General {{{ 
set autowrite          " Flush to disk when using :make and stuff
set backspace=indent,eol,start " Allow backspacing over everything
set confirm            " Confirm various potentially dangerous actions
set hidden             " Enable hidden buffers - :bn w/ changes!
set magic              " Allows extended regexes
set nocompatible       " Don't use Vi settings!
set noerrorbells       " No annoying beeping
set noinsertmode       " Don't make Vim insert-only! Weirdo!
set shell=/bin/bash    " zsh screws up 
set ttimeoutlen=50     " 50 milliseconds for esc timeout instead of 1000
set ttyfast            " We are always going to be using a fast terminal.
filetype plugin indent on " File type detection on, (cindent for .c etc)
" }}}
" Appearance {{{
set background=light  " Dark term bg (but bg=dark is gross)
set hlsearch          " Hilight /search results!
set incsearch         " do incremental searching
set lazyredraw        " don't redraw screen during macros and stuff
set list              " Display listchars (see below)!        
set listchars=tab:>=,trail:$ " display tabs as >==== and trailing spaces as $
set matchtime=3       " 3/10 of a second for showmatch
set noicon            " Weird GUI thing. Want none!
set nomore            " No spacing through messages!
set nonumber          " Don't display line numbers on the side
set notitle           " Don't display name of file and stuff in term title
set report=0          " Show a 'N lines were changed' report always
set ruler             " Show current cursor position
set scrolloff=3       " Scroll screen at 3 lines from top/bottom
set shortmess=aIoO    " a=terse(s/[modified]/[+]/),I=nointro,oO=:bn no message
" set showcmd           " display info on current selected visual field
set showmatch         " Hilight the other bracket
set showmode          " Show the current mode
set vb t_vb=          " Turns off all belly things
set wildchar=<TAB>    " Use tab as the tab key!
set wildmenu          " Display a tab-completion menu for most things
set wildignore+=*.pyc,*.zip,*.gz,*.tar,*.o,*.so " Don't open these files
syntax on             " Do syntax hilighting
" }}}
" Tabs and margins {{{
set tabstop=4     " Tab characters = 8 spaces when displayed
set shiftwidth=4  " Use 4 spaces for each insertion of (auto)indent
set softtabstop=4 " Tabs 'count for' 4 spaces when editing (fake tabs)
set expandtab     " <tab> -> spaces in insert mode
set autoindent	  " always set autoindenting on
set smarttab      " Smart tabbing!
set shiftround    " < and > will hit indent levels instead of +-4 always
" set tw=80       " Make hard CR every 80 lines
" }}}
" Inter-session stuff {{{
" set viminfo='50,/50,:50,<50,n~/.viminfo
set history=100	" keep 100 lines of command line history
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
set commentstring="%s 
set dict=/usr/share/dict/words
set tildeop           " Turn ~ into an operator
let g:EnhCommentifyBindInInsert = 'No' " No enhancedcommentify in insert mode
let g:EnhCommentifyRespectIndent = 'Yes' " indent where I want you to indent
"}}}
" }}}
" Mappings {{{
" Use <C-t> like irssi to transpose characters in insert mode {{{
imap  <Esc>xpli
"}}}
" Map Q to format line {{{
map Q gq 
" }}}
" Insert a single char (space unused in cmd mode) {{{
nmap <Space> i<Space><Esc>r
" }}}
" {{{ F5 -> toggle :set paste
set pastetoggle=<f5>
" }}}
" F11 -> spellcheck hilighting on {{{
map <F11> :call <SID>spell()<CR>
imap <F11> <Esc>:call <SID>spell()<CR>
" }}}
" F12 -> toggle :set number {{{
map <F12> :set number!<CR>
" }}}
" Make tab useful {{{
"inoremap <Tab>   <C-R>=TabWrapper(">")<CR>
"inoremap <S-Tab> <C-R>=TabWrapper("<")<CR>
" }}}
" Make ctrl-n and ctrl-p cycle through buffers in cmd mode {{{
nnoremap <C-N> :bn<Enter>
nnoremap <C-P> :bp<Enter>
" }}}
" Get rid of annoying q: window typo! {{{
" "nmap q: :q
" }}}
" }}}
" Autocommands {{{
" Send .vimrc, .zshrc, and templates to shells after I edit them. {{{
au BufWritePost ~/.vimrc !~/bin/scp-to-shells ~/.vimrc
au BufWritePost ~/.zshrc !~/bin/scp-to-shells ~/.zshrc
" }}}
" Jump to last known cursor position on file edit {{{
au BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\   exe "normal g`\"" |
\ endif
" }}}
" Auto +x {{{
au BufWritePost *.sh !/bin/bash -c 'if [ -x % ]; then exit; else /bin/chmod +x %; fi'
au BufWritePost *.pl !/bin/bash -c 'if [ -x % ]; then exit; else /bin/chmod +x %; fi'
au BufWritePost *.py !/bin/bash -c 'if [ -x % ]; then exit; else /bin/chmod +x %; fi'
"}}}
" Autoindent for python files. {{{
"au BufRead,BufNewFile *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
"au BufRead,BufNewFile *.py so ~/.vim/python_fold.vim
" }}}
" Use levdes syntax for .des files {{{
au BufRead,BufNewFile *.des set syntax=levdes
" }}}
" Python :make support{{{
autocmd BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
" }}}
au Filetype java setlocal omnifunc=javacomplete#Complete
" }}}
" Colors {{{
"autocmd BufWinEnter * syn match EOLWS excludenl /[ \t]\+$/
"highlight EOLWS      ctermbg=red
highlight Pmenu      ctermfg=grey ctermbg=darkblue
highlight PmenuSel   ctermfg=red  ctermbg=darkblue
highlight PmenuSbar  ctermbg=cyan
highlight PmenuThumb ctermfg=red
highlight Folded     ctermbg=black ctermfg=darkgreen
highlight Search     None          ctermfg=lightred

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
" Helper Functions {{{
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
" make the tab key useful {{{
function TabWrapper(dir)
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<Tab>"
  elseif a:dir == ">"
    return "\<C-N>"
  elseif a:dir == "<"
    return "\<C-P>"
  endif
endfunction " }}}
" }}}

" diff between current file and its original state {{{
function s:difforig()
    vert new
    set bt=nofile
    read #
    normal 0d_
    diffthis
    wincmd p
    diffthis
endfunction
function s:diffstop()
    diffoff!
    wincmd t
    quit
endfunction
nmap <silent> ds :call <SID>difforig()<CR>
nmap <silent> de :call <SID>diffstop()<CR>
" }}}

set udf
" vim:fdm=marker commentstring="%s
