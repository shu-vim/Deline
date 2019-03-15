function! deline#hl(h)
    if type(a:h) == 0
        return "%" . string(a:h) . "*"
    else
        return "%#" . a:h . "#"
    endif
endfunction

" can not put statusline expressions
function! deline#if(expr,t,f)
    return "%{" . a:expr . "?'" . a:t . "':'" . a:f . "'}"
endfunction

function! deline#expr(expr)
    return "%{" . a:expr . "}"
endfunction

function! deline#comment(text)
    return ""
endfunction

function! deline#system(cmd)
    return "%{system('" . a:cmd . "')}"
endfunction

function! deline#strftime(fmt)
    return "%{strftime('" . a:fmt . "')}"
endfunction

function! deline#space()
    return ' '
endfunction

function! deline#bar()
    return '|'
endfunction

function! deline#rightalign()
    return '%='
endfunction

function! deline#file(fmt)
    return "%{deline#fileInner('" . a:fmt . "')}"
endfunction

function! deline#modified(t,f)
    return "%{&modified?'" . a:t . "':'". a:f . "'}"
endfunction

function! deline#readonly(t,f)
    return "%{&readonly||!(&modifiable)?'" . a:t . "':'". a:f . "'}"
endfunction

function! deline#helpfile()
    return "%h"
endfunction

function! deline#preview()
    return "%w"
endfunction

function! deline#quickfix()
    return "%q"
endfunction

function! deline#keymap()
    return "%k"
endfunction

function! deline#bufnr()
    return "%n"
endfunction

function! deline#char()
    return "%b"
endfunction

function! deline#charhex()
    return "%B"
endfunction

function! deline#offset()
    return "%o"
endfunction

function! deline#offsethex()
    return "%O"
endfunction

function! deline#page()
    return "%N"
endfunction

function! deline#line()
    return "%4l"
endfunction

function! deline#numlines()
    return "%4L"
endfunction

function! deline#column()
    return "%3c"
endfunction

function! deline#columnv()
    return "%3v"
endfunction

function! deline#columnvoptional()
    return "%V"
endfunction

function! deline#linepercent()
    return "%p"
endfunction

function! deline#winpercent()
    return "%P"
endfunction

function! deline#argpos()
    return "%a"
endfunction

function! deline#filetype()
    return "%{&filetype}"
endfunction

function! deline#fileformat()
    return "%{&fileformat}"
endfunction

function! deline#fileencoding()
    return "%{&fileencoding}"
endfunction

function! deline#mode()
    return "%{deline#modeInner()}"
endfunction

function! deline#modeHL(hlname)
    let hlname = a:hlname
    if hlname == ""
        let hlname = "User2"
    endif
    return "%{deline#modeHLInner('" . hlname . "')}"
endfunction

function! deline#notsaved(min_ago)
    return "%{deline#notsavedInner(" . a:min_ago . ")}"
endfunction

function! deline#filehead(filepath, interval)
    return "%{deline#fileheadInner('" . a:filepath . "', " . string(a:interval) . ")}"
endfunction

function! deline#filetail(filepath, interval)
    return "%{deline#filetailInner('" . a:filepath . "', " . string(a:interval) . ")}"
endfunction

"==================================================

function! deline#_config_get(key, defvalue)
    if trim(a:key) == "" | return a:defvalue | endif

    let c = s:config

    let keys = split(a:key, "/")
    for i in range(len(keys))
        let k = trim(keys[i])

        if i == len(keys) - 1
            let c = get(c, k, a:defvalue)
        else
            let c = get(c, k, {})
        endif
    endfor

    return c
endfunction

function! deline#_config_set(key, value)
    if trim(a:key) == "" | return | endif

    let c = s:config

    let keys = split(a:key, "/")
    for i in range(len(keys))
        let k = trim(keys[i])

        if i == len(keys) - 1
            let c[k] = a:value
        else
            let ctest = get(c, k, {})
            if empty(ctest)
                let c[k] = {}
                let c = c[k]
            else
                let c = ctest
            endif
        endif
    endfor
endfunction

function! deline#_set(list)
    let g:Deline__statusline = a:list
    call deline#_apply()
endfunction

function! deline#_apply()
    let dynamic = 0
    let temp = ""
    for c in g:Deline__statusline
        if type(c) == 4
            let dynamic = 1
            let temp = temp . deline#dynamic#_eval(c)
        else
            let temp = temp . c
        endif
    endfor

    if dynamic
        let temp = temp . "%{deline#dynamic#_hook(". string(get(s:config, "interval", 0.5)) .")}"
    endif

    let &statusline = temp
    redraw
endfunction

function! deline#_init()
    let s:config = {
                \ "hl_1": {
                    \ "guifg": "#cccccc",
                    \ "guibg": "#333333",
                    \ "ctermfg": "White",
                    \ "ctermbg": "DarkGray",
                \ },
                \ "hl_3": {
                    \ "guifg": "#777777",
                    \ "guibg": "#333333",
                    \ "ctermfg": "LightGray",
                    \ "ctermbg": "DarkGray",
                \ },
                \ "hl_4": {
                    \ "guifg": "#ffbbbb",
                    \ "guibg": "#333333",
                    \ "ctermfg": "DarkRed",
                    \ "ctermbg": "DarkGray",
                \ },
                \ "no_name": "[No Name]",
                \ "mode_n": {
                    \ "": " NORMAL  ",
                    \ "guifg": "#000000",
                    \ "guibg": "#aaddee",
                    \ "gui": "bold",
                    \ "ctermfg": "Black",
                    \ "ctermbg": "Cyan",
                    \ "term": "bold",
                    \ },
                \ "mode_i": {
                    \ "": " INSERT  ",
                    \ "guifg": "#000000",
                    \ "guibg": "#aaeeaa",
                    \ "gui": "bold",
                    \ "ctermfg": "Black",
                    \ "ctermbg": "LightGreen",
                    \ "term": "bold",
                    \ },
                \ "mode_R": {
                    \ "": " REPLACE ",
                    \ "guifg": "#000000",
                    \ "guibg": "#ff7777",
                    \ "gui": "bold",
                    \ "ctermfg": "Black",
                    \ "ctermbg": "LightRed",
                    \ "term": "bold",
                    \ },
                \ "mode_v": {
                    \ "": " VISUAL  ",
                    \ "guifg": "#000000",
                    \ "guibg": "#ffff77",
                    \ "gui": "bold",
                    \ "ctermfg": "Black",
                    \ "ctermbg": "LightYellow",
                    \ "term": "bold",
                    \ },
                \ "mode_V": {
                    \ "": " VISUAL  ",
                    \ "guifg": "#000000",
                    \ "guibg": "#ffff77",
                    \ "gui": "bold",
                    \ "ctermfg": "Black",
                    \ "ctermbg": "LightYellow",
                    \ "term": "bold",
                    \ },
                \ "mode_": {
                    \ "": " VISUAL  ",
                    \ "guifg": "#000000",
                    \ "guibg": "#ffff77",
                    \ "gui": "bold",
                    \ "ctermfg": "Black",
                    \ "ctermbg": "LightYellow",
                    \ "term": "bold",
                    \ },
                \ "mode_c": {
                    \ "": " COMMAND ",
                    \ "guifg": "#000000",
                    \ "guibg": "#ffff77",
                    \ "gui": "bold",
                    \ "ctermfg": "Black",
                    \ "ctermbg": "LightYellow",
                    \ "term": "bold",
                    \ },
                \ "interval": 0.5,
                \ }

    "let g:Deline__hookInterval = 0.5 "seconds
    let g:Deline__hookLastReltime = reltime()

    let g:Deline__statusline = []

    let g:Deline__hooking = 0

    call deline#_initHighlight()
endfunction

function! deline#_initHighlight()
    call deline#_highlight("User1", get(s:config, "hl_1", {}))
    "
    call deline#_highlight("User3", get(s:config, "hl_3", {}))
    call deline#_highlight("User4", get(s:config, "hl_4", {}))
    redraw
endfunction

function! deline#_config(config)
    let shouldinit = 0

    for k in keys(a:config)
        if k == "" || k == "|"
            let shouldinit = 1
        endif

        let s:config[k] = a:config[k]
    endfor

    if shouldinit
        call deline#_initHighlight()
    endif
endfunction

function! deline#_highlight(name, dict)
    let hl = ""
    for k in keys(a:dict)
        if k == "" | continue | endif
        let hl = hl . " " . k . "='" . a:dict[k] . "'"
    endfor
    silent execute "highlight " . a:name . " " . hl
    "redraw
endfunction

let s:fileInnerCache = {} " {bufnr(num): {fmt(string): {value: (string), age: (num)}}}
function! deline#fileInner(fmt)
    let bufnr = bufnr("%")
    if has_key(s:fileInnerCache, bufnr) && has_key(s:fileInnerCache[bufnr], a:fmt)
        let va = s:fileInnerCache[bufnr][a:fmt]
        if va.age > 0
            let s:fileInnerCache[bufnr][a:fmt].age = s:fileInnerCache[bufnr][a:fmt].age - 1
            return va.value
        endif
    endif

    if bufname("%") == ""
        let v = ""
        if a:fmt =~ ':p:t'
            let v = get(s:config, "no_name", "[No Name]")
        else
            let v = ""
        endif

        let s:fileInnerCache[bufnr] = {
                    \ a:fmt: {
                    \   "value": v,
                    \   "age": 25,
                    \ },
                    \ }
        return v
    endif

    let v = ""
    for f in split(a:fmt, "/")
        if v != ""
            let v = v . "/"
        endif

        try
            let g = matchlist(f, '^\v([^:])*(%(:\w)+)(.*)')
            let v = v . g[1] . expand("%" . g[2]) . g[3]
        catch
            let v = v . expand("%" . f)
        endtry
    endfor

    let age = 0
    if a:fmt =~ ':p:t'
        let age = 1000
    else
        let age = 10000
    endif

    if !has_key(s:fileInnerCache, bufnr)
        let s:fileInnerCache[bufnr] = {
                    \ a:fmt: {
                    \   "value": v,
                    \   "age": age,
                    \ },
                    \ }
    else
        let s:fileInnerCache[bufnr][a:fmt] = {
                    \   "value": v,
                    \   "age": age,
                    \ }
    endif
    return v
endfunction

function! deline#modeInner()
    let mode = mode()
    if mode == "n"
        return "NORMAL "
    elseif mode == "i"
        return "INSERT "
    elseif mode == "R"
        return "REPLACE"
    elseif mode == "v" || mode == "V" || mode == ""
        return "VISUAL "
    elseif mode == "c"
        return "COMMAND"
    else
        return "NORMAL "
    endif
endfunction


let s:last_mode = '0'
function! deline#modeHLInner(hlname)
    let mode = mode()

    let hlinfo = get(s:config, "mode_" . mode, {})
    if empty(hlinfo)
        return ""
    endif

    "if mode != get(s:config, "last_mode", "")
    if mode != s:last_mode
        call deline#_highlight(a:hlname, get(s:config, "mode_" . mode, {}))
        redraw

        let s:last_mode = mode
    endif

    return ""
endfunction

"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! deline#notsavedInner(min_ago)
    let t = undotree()
    let seq = t.seq_cur
    let s = t.save_cur

    if len(t.entries) == 0
        return ""
    endif

    " e is the last saved
    let found = 0
    for e in t.entries
        if has_key(e, "save") && e.save == s
            let found = 1
            break
        endif
    endfor
    if found == 0
        let ee = t.entries[0]
    else
        if e.seq == seq
            return ""
        endif

        " ee is the first change after save
        for ee in t.entries
            if ee.seq == e.seq + 1
                break
            endif
        endfor
    endif

    let now = localtime()
    let d = now - ee.time
    let dh = d / float2nr(60*60)
    let dm = float2nr(d % (60*60) / 60)

    if a:min_ago > dh*60 + dm
        return ""
    endif

    let result = ""
    if dh != 0
        let result = string(dh)."h"
    endif
    if dm != 0
        let result = result . string(dm)."m"
    endif
    return result

    for e in t.entries
        if has_key(e, "save") && e.save == s
            if e.seq == seq
                return ""
            endif

            " ee is the first change after save
            for ee in t.entries
                if ee.seq == e.seq + 1
                    break
                endif
            endfor

            let now = localtime()
            let d = now - ee.time
            let dh = d / float2nr(60*60)
            let dm = float2nr(d % (60*60) / 60)

            if a:min_ago > dh*60 + dm
                return ""
            endif

            let result = ""
            if dh != 0
                let result = string(dh)."h"
            endif
            if dm != 0
                let result = result . string(dm)."m"
            endif
            return result
        endif
    endfor

    return ""
endfunction

"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

let s:fileheadCache = {} " {filepath: {reltime: (num), modtime: (num), value: (string)}}

function! deline#fileheadInner(filepath, interval)
    if has_key(s:fileheadCache, a:filepath)
        let ht = s:fileheadCache[a:filepath]
        if reltimefloat(reltime(ht.reltime)) * 1000 < a:interval
            return ht.value
        endif
        if ht.modtime >= getftime(a:filepath)
            return ht.value
        endif
    endif

    try
        let line = readfile(expand(a:filepath), "", 1)[0]
    catch
        let line = ""
    endtr

    let s:fileheadCache[a:filepath] = {
                \ "reltime": reltime(),
                \ "modtime": getftime(a:filepath),
                \ "value": line,
                \ }

    return line
endfunction

"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! deline#filetailInner(filepath, interval)
    if has_key(s:fileheadCache, a:filepath)
        let ht = s:fileheadCache[a:filepath]
        if reltimefloat(reltime(ht.reltime)) * 1000 < a:interval
            return ht.value
        endif
        if ht.modtime >= getftime(a:filepath)
            return ht.value
        endif
    endif

    try
        let line = readfile(expand(a:filepath))[-1]
    catch
        let line = ""
    endtr

    let s:fileheadCache[a:filepath] = {
                \ "reltime": reltime(),
                \ "modtime": getftime(a:filepath),
                \ "value": line,
                \ }

    return line
endfunction
