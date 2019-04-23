function! deline#dynamic#expr(expr)
    let d = {"expr": a:expr}
    function! d.eval() dict
        return eval(self.expr)
    endfunction
    return d
endfunction

"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! deline#dynamic#if(expr, t, f)
    let d = {
                \ "expr": a:expr,
                \ "t": a:t,
                \ "f": a:f,
                \ }
    function! d.eval() dict
        let v = eval(self.expr) ? self.t : self.f
        return deline#dynamic#_eval(v)
    endfunction
    return d
endfunction

"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! deline#dynamic#cyclic(list)
    let d = {
                \ "list": a:list,
                \ "seq": 0
                \ }
    function! d.eval() dict
        let seq = self.seq + 1
        if seq > len(self.list)
            let seq = 0
        endif
        let self.seq = seq
        return self.list[seq-1]
    endfunction
    return d
endfunction

"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

let s:periodic_timer_id = 0
function! deline#dynamic#periodic(period)
    let d = {"period": a:period}
    function! d.eval() dict
        if s:periodic_timer_id == 0
            let s:periodic_timer_id = timer_start(self.period, "deline#dynamic#_reload", {'repeat': -1})
        endif
        return ""
    endfunction
    return d
endfunction

function! deline#dynamic#_reload(id)
    "call timer_stop(a:id)

    " invokes deline#dynamic#_hook
    let temp = &statusline
    let &statusline = ""
    let &statusline = temp
endfunction

"==================================================

function! deline#dynamic#_hook(interval)
    if g:Deline__hooking | return | endif

    let interval = reltimefloat(reltime(g:Deline__hookLastReltime))
    if interval <= a:interval | return "" | endif
    let g:Deline__hookLastReltime = reltime()

    let g:Deline__hooking = 1
    call deline#_apply()
    let g:Deline__hooking = 0

    return ""
endfunction

function! deline#dynamic#_eval(v)
    if type(a:v) == 4 "Dict
        return a:v.eval()
    else
        return a:v
    endif
endfunction
