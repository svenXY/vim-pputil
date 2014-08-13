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
endfu
