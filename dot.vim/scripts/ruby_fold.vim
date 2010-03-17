function GetPerlFold()
   if getline(v:lnum) =~ '^\s*def'
      return ">1"
   elseif getline(v:lnum + 2) =~ '^\s*def' && getline(v:lnum + 1) =~ '^\s*$'
      return "<1"
   else
      return "="
   endif
endfunction
setlocal foldexpr=GetPerlFold()
setlocal foldmethod=expr 
