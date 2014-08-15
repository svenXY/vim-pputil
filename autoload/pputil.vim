" replace an include line with class line(s)
function! pputil#Inc2Class()
    let incline = getline('.')
     if stridx(incline,"include") >=  0
         " get string before include
         let filler = matchstr(incline,'\v^.*\zeinclude')
         " get string after include (i.e. the classname(s)
         let rest   = matchstr(incline,'include \zs.*')
         " split them at comma if necessary
         let ll = split(rest, '\v, ?')
         " make it into a list of correct lines
         let ll = map(ll, 'filler . "class {\"" . v:val . "\": }"')
         " store line position for cleanup
         let pos = getpos('.')[1]
         " add lines
         call append('.', ll)
         " cleanup - jump back and delete the line
         execute "normal! " . pos . "ggdd"
         " go down n lines
         let down = len(ll) - 1
         if down > 0
             execute "normal! " . down . "j"
         endif
    else
         echom 'No include line'
    endif
endfu

function! pputil#CleanUp()
    normal! ggVG=gg
    retab
    redraw | echom 'Cleaned up whole file'
endfu

function! pputil#Xplode()
    let line = getline('.')
    " add newlines where appropriate (after ']},:' and before ']}' )
    " checks not to split at '::' - see the @! and @<! zero-width construct
    let line = substitute(line, '\v(([\[{,])|((:)@<!:(:)@!))\s?', '\1\n', 'ge')
    let line = substitute(line, '\v([\]}])\s?', '\n\1', 'ge')
    " collapse whitespace
    let line = substitute(line, '\v\s+', ' ', 'ge')
    " set nice arrows
    let line = substitute(line, '\v\s*\=\>\s*', ' => ', 'ge')
    " split into list to write back into buffer
    let lines = split(line, '\n')
    let lines = map(lines, '<SID>Rtrim(v:val)')
    let down = len(lines) - 1
    " replace the line
    call setline('.', lines[0])
    " append additional lines
    if len(lines) > 1
        call append('.', lines[1:])
    endif
    " mark modified/new lines visually
    " and autoindent
    execute "normal! V"
    if down >0
        execute "normal! ". down . "j"
    endif
    normal! =
    if exists(':Tabularize')
        normal! gv:Tabularize /=>
    endif
    " and autoindent again (just to be safe)
    normal! gv=
endfu

function! s:Rtrim(string)
    let str = a:string
    let str = substitute(str, '\v\s+$', '', 'ge')
    return str
endfu
