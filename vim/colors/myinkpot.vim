" Vim color file
" Name:       inkpot.vim
" Maintainer: Ciaran McCreesh <ciaranm@gentoo.org>
" This should work in the GUI, rxvt-unicode (88 colour mode) and xterm (256
" colour mode). It won't work in 8/16 colour terminals.

set background=dark
hi clear
if exists("syntax_on")
   syntax reset
endif

let colors_name = "inkpot"

" map a urxvt cube number to an xterm-256 cube number
fun! <SID>M(a)
    return strpart("0135", a:a, 1) + 0
endfun

" map a urxvt colour to an xterm-256 colour
fun! <SID>X(a)
    if &t_Co == 88
        return a:a
    else
        if a:a == 8
            return 237
        elseif a:a < 16
            return a:a
        elseif a:a > 79
            return 232 + (3 * (a:a - 80))
        else
            let l:b = a:a - 16
            let l:x = l:b % 4
            let l:y = (l:b / 4) % 4
            let l:z = (l:b / 16)
            return 16 + <SID>M(l:x) + (6 * <SID>M(l:y)) + (36 * <SID>M(l:z))
        endif
    endif
endfun

if has("gui_running")
    exec "echo 'GUI is for closers!'"
endif
exec "hi Normal cterm=NONE ctermfg=".<SID>X("78")."ctermbg=NONE"
exec "hi IncSearch cterm=reverse"
exec "hi Search cterm=BOLD ctermfg=09 ctermbg=NONE"
exec "hi ErrorMsg cterm=BOLD ctermfg=".<SID>X("79")."ctermbg=".<SID>X(64).""
exec "hi WarningMsg cterm=BOLD ctermfg=".<SID>X("79")."ctermbg=".<SID>X(68).""
exec "hi ModeMsg cterm=BOLD ctermfg=".<SID>X("39").""
exec "hi MoreMsg cterm=BOLD ctermfg=".<SID>X("39").""
exec "hi Question cterm=BOLD ctermfg=".<SID>X("72").""
exec "hi StatusLine cterm=BOLD ctermfg=".<SID>X("84")."ctermbg=".<SID>X(81).""
exec "hi StatusLineNC cterm=NONE ctermfg=".<SID>X("84")."ctermbg=".<SID>X(81).""
exec "hi VertSplit cterm=NONE ctermfg=".<SID>X("84")."ctermbg=".<SID>X(82).""
exec "hi WildMenu cterm=BOLD ctermfg=190 ctermbg=NONE"

exec "hi DiffText cterm=NONE ctermfg=".<SID>X("78")."ctermbg=".<SID>X(24).""
exec "hi DiffChange cterm=NONE ctermfg=".<SID>X("78")."ctermbg=".<SID>X(23).""
exec "hi DiffDelete cterm=NONE ctermfg=".<SID>X("78")."ctermbg=".<SID>X(48).""
exec "hi DiffAdd cterm=NONE ctermfg=".<SID>X("78")."ctermbg=".<SID>X(24).""

exec "hi Cursor cterm=NONE ctermfg=".<SID>X("8")." ctermbg=".<SID>X(39).""
exec "hi lCursor cterm=NONE ctermfg=".<SID>X("8")." ctermbg=".<SID>X(39).""
exec "hi CursorIM cterm=NONE ctermfg=".<SID>X("8")." ctermbg=".<SID>X(39).""

exec "hi Folded cterm=NONE ctermfg=35 ctermbg=NONE"
exec "hi FoldColumn cterm=NONE ctermfg=".<SID>X("8")."ctermbg=NONE"

exec "hi Directory cterm=NONE ctermfg=".<SID>X("29")."ctermbg=NONE"
exec "hi LineNr cterm=NONE ctermfg=".<SID>X("38")."ctermbg=NONE"
exec "hi NonText cterm=BOLD ctermfg=".<SID>X("38")."ctermbg=NONE"
exec "hi SpecialKey cterm=BOLD ctermfg=".<SID>X("34")."ctermbg=NONE"
exec "hi Title cterm=BOLD ctermfg=".<SID>X("52")."ctermbg=NONE"
exec "hi Visual cterm=NONE ctermfg=".<SID>X("80")."ctermbg=".<SID>X(73).""

exec "hi Comment cterm=NONE ctermfg=".<SID>X("52")."ctermbg=NONE"
exec "hi Constant cterm=NONE ctermfg=".<SID>X("73")."ctermbg=NONE"
exec "hi String cterm=NONE ctermfg=".<SID>X("01")."ctermbg=NONE"
exec "hi Error cterm=NONE ctermfg=".<SID>X("79")."ctermbg=".<SID>X(64).""
exec "hi Identifier cterm=NONE ctermfg=".<SID>X("71")."ctermbg=NONE"
exec "hi Ignore cterm=NONE ctermfg=".<SID>X("38")."ctermbg=NONE"
exec "hi Number cterm=NONE ctermfg=".<SID>X("22")."ctermbg=NONE"
exec "hi PreProc cterm=NONE ctermfg=".<SID>X("10")."ctermbg=NONE"
exec "hi Special cterm=NONE ctermfg=".<SID>X("39")."ctermbg=NONE"
exec "hi Statement cterm=NONE ctermfg=".<SID>X("26")."ctermbg=NONE"
exec "hi Todo cterm=BOLD ctermfg=".<SID>X("08")."ctermbg=".<SID>X(39).""
exec "hi Type cterm=NONE ctermfg=".<SID>X("71")."ctermbg=NONE"
exec "hi Underlined cterm=BOLD ctermfg=".<SID>X("78")."ctermbg=NONE"
exec "hi TaglistTagName cterm=BOLD ctermfg=".<SID>X("26")."ctermbg=NONE"

exec "hi CursorLine cterm=NONE ctermbg=52"

" vim: set et :
