
"""change highlight {hlname}.
function! deline#hl(hlname)
    if type(a:hlname) == 0
        return "%" . string(a:hlname) . "*"
    else
        return "%#" . a:hlname . "#"
    endif
endfunction

"""evaluates {expr} and returns {t} or {f}
function! deline#if(expr,t,f)
    return "%{" . a:expr . "?'" . a:t . "':'" . a:f . "'}"
endfunction

"""evaluated vim expr
function! deline#expr(expr)
    return "%{" . a:expr . "}"
endfunction

"""comment (simply ignored as statusline)
function! deline#comment(text)
    return ""
endfunction

"""|system()|
function! deline#system(cmd)
    return "%{system('" . a:cmd . "')}"
endfunction

"""|strftime()|
function! deline#strftime(fmt)
    return "%{strftime('" . a:fmt . "')}"
endfunction

"""' '
function! deline#space()
    return ' '
endfunction

"""|
function! deline#bar()
    return '|'
endfunction

"""%=
function! deline#rightalign()
    return '%='
endfunction

"""file name
function! deline#file(fmt)
    return "%{deline#fileInner('" . a:fmt . "')}"
endfunction

"""returns {t} if &modified, else {f}
function! deline#modified(t,f)
    return "%{&modified?'" . a:t . "':'". a:f . "'}"
endfunction

"""returns {t} if &readonly, else {f}
function! deline#readonly(t,f)
    return "%{&readonly||!(&modifiable)?'" . a:t . "':'". a:f . "'}"
endfunction

"""%h
function! deline#helpfile()
    return "%h"
endfunction

"""%w
function! deline#preview()
    return "%w"
endfunction

"""%q
function! deline#quickfix()
    return "%q"
endfunction

"""%k
function! deline#keymap()
    return "%k"
endfunction

"""%n
function! deline#bufnr()
    return "%n"
endfunction

"""%b
function! deline#char()
    return "%b"
endfunction

"""%B
function! deline#charhex()
    return "%B"
endfunction

"""%o
function! deline#offset()
    return "%o"
endfunction

"""%O
function! deline#offsethex()
    return "%O"
endfunction

"""%N
function! deline#page()
    return "%N"
endfunction

"""%l
function! deline#line()
    return "%4l"
endfunction

"""%L
function! deline#numlines()
    return "%4L"
endfunction

"""%c
function! deline#column()
    return "%3c"
endfunction

"""%v
function! deline#columnv()
    return "%3v"
endfunction

"""%V
function! deline#columnvoptional()
    return "%V"
endfunction

"""%p
function! deline#linepercent()
    return "%p"
endfunction

"""%P
function! deline#winpercent()
    return "%P"
endfunction

"""%a
function! deline#argpos()
    return "%a"
endfunction

"""&filetype
function! deline#filetype()
    return "%{&filetype}"
endfunction

"""&fileformat
function! deline#fileformat()
    return "%{&fileformat}"
endfunction

"""&fileencoding
function! deline#fileencoding()
    return "%{&fileencoding}"
endfunction

"""the name of mode 'NORMAL', ...
function! deline#mode()
    return "%{deline#modeInner()}"
endfunction

"""DEPLICATED. re-define highlight as {hlname}
function! deline#modeHL(hlname)
    return deline#defHLMode(a:hlname)
endfunction

"""re-define highlight as {hlname}
function! deline#defHLMode(hlname)
    let hlname = a:hlname
    if hlname == ""
        let hlname = "User2"
    endif
    return "%{deline#defHLModeInner('" . hlname . "')}"
endfunction

""" define highlight {hlname} with "attr=value attr=value ..." format string {attrs}
function! deline#defHL(hlname, attrs)
    return "%{deline#defHLInner('" . a:hlname . "', '" . a:attrs . "')}"
endfunction

""" define highlight {hlname} from inverted {basehlname}
function! deline#defHLInv(hlname, basehlname)
    return "%{deline#defHLInvInner('" . a:hlname . "', '" . a:basehlname . "')}"
endfunction

""" define combined highlight {hlname} from fg:{fghlname} and bg:{bghlname}
"""
""" {fghlname} and {bghlname} can be "attr=value attr=value ..." format string.
function! deline#defHLCombined(hlname, fghlname, bghlname)
    return "%{deline#defHLCombinedInner('" . a:hlname . "', '" . a:fghlname . "', '" . a:bghlname . "')}"
endfunction

""" define combined highlight {hlname} from fg:bg of {lhlname} and bg:bg of {rhlname}
function! deline#defHLBGTrans(hlname, lhlname, rhlname)
    return "%{deline#defHLBGTransInner('" . a:hlname . "', '" . a:lhlname . "', '" . a:rhlname . "')}"
endfunction

"""displays delta time from last save. 
"""
"""Returns duration from last save in "{hour}h{minute}m" format.
"""{min_ago} is a Number to suppress output if the duration(in minute) < {min_ago}. 
function! deline#notsaved(min_ago)
    return "%{deline#notsavedInner(" . a:min_ago . ")}"
endfunction

"""displays the first line of the {filepath} at {inteerval}.
function! deline#filehead(filepath, interval)
    return "%{deline#fileheadInner('" . a:filepath . "', " . string(a:interval) . ")}"
endfunction

"""displays the last line of the {filepath} at {inteerval}.
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
    let s:config["_hlonce"] = {}

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
    " let defva = {"age": 0}
    " let va = get(get(s:fileInnerCache, bufnr, {}), a:fmt, defva)
    " if va.age > 0
    "     let s:fileInnerCache[bufnr][a:fmt].age = s:fileInnerCache[bufnr][a:fmt].age - 1
    "     return va.value
    " endif
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
                    \ a:fmt : {
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
                    \ a:fmt : {
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
function! deline#defHLModeInner(hlname)
    let mode = mode()

    if mode != s:last_mode
        let hlinfo = get(s:config, "mode_" . mode, {})
        if empty(hlinfo)
            return ""
        endif

        call deline#_highlight(a:hlname, hlinfo)
        redraw

        let s:last_mode = mode
    endif

    return ""
endfunction

let s:last_inv_mode = '0'
function! deline#modeHLInvInner(hlname)
    let mode = mode()

    if mode != s:last_inv_mode
        let hlinfo = get(s:config, "mode_" . mode, {})
        if empty(hlinfo)
            return ""
        endif

        let hlinfo = copy(hlinfo)

        let guibg = get(hlinfo, "guifg", "")
        let guifg = get(hlinfo, "guibg", "")
        let ctermbg = get(hlinfo, "ctermfg", "")
        let ctermfg = get(hlinfo, "ctermbg", "")

        if guibg != "" | let hlinfo["guibg"] = guibg | endif
        if guifg != "" | let hlinfo["guifg"] = guifg | endif
        if ctermbg != "" | let hlinfo["ctermbg"] = ctermbg | endif
        if ctermfg != "" | let hlinfo["ctermfg"] = ctermfg | endif

        call deline#_highlight(a:hlname, hlinfo)
        redraw

        let s:last_inv_mode = mode
    endif

    return ""
endfunction

"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! deline#defHLInner(hlname, attrs)
    if get(s:config["_hlonce"], a:hlname, "") == ""
        let s:config["_hlonce"][a:hlname] = "*"
    else
        return ""
    endif

    "term=bold ctermfg=16 ctermbg=231 guifg=#bbbbbb guibg=#ffffff
    let hh = split(a:attrs, '\%(\\\)\@<!\(\s\|\n\)')
    let hldict = {}
    for c in hh
        let cc = split(c, "=")
        if len(cc) == 2
            let hldict[cc[0]] = cc[1]
        endif
    endfor

    call deline#_highlight(a:hlname, hldict)
    
    return ""
endfunction

"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! deline#defHLInvInner(hlname, basehlname)
    if get(s:config["_hlonce"], a:hlname, "") == ""
        let s:config["_hlonce"][a:hlname] = "*"
    else
        return ""
    endif

    silent let hl = deline#_parseHL(a:basehlname)

    let guibg = get(hl, "guifg", "")
    let guifg = get(hl, "guibg", "")
    let ctermbg = get(hl, "ctermfg", "")
    let ctermfg = get(hl, "ctermbg", "")

    if guibg != "" | let hl["guibg"] = guibg | endif
    if guifg != "" | let hl["guifg"] = guifg | endif
    if ctermbg != "" | let hl["ctermbg"] = ctermbg | endif
    if ctermfg != "" | let hl["ctermfg"] = ctermfg | endif

    call deline#_highlight(a:hlname, hl)

    return ""
endfunction

"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! deline#defHLCombinedInner(hlname, fghlname, bghlname)
    if get(s:config["_hlonce"], a:hlname, "") == ""
        let s:config["_hlonce"][a:hlname] = "*"
    else
        return ""
    endif

    if a:fghlname =~ "="
        silent let fghl = deline#_parseHLAttrs(a:fghlname)
    else
        silent let fghl = deline#_parseHL(a:fghlname)
    endif

    if a:bghlname =~ "="
        silent let bghl = deline#_parseHLAttrs(a:bghlname)
    else
        silent let bghl = deline#_parseHL(a:bghlname)
    endif
        

    let hl = copy(fghl)

    let guibg = get(bghl, "guibg", "")
    let ctermbg = get(bghl, "ctermbg", "")

    if guibg != "" | let hl["guibg"] = guibg | endif
    if ctermbg != "" | let hl["ctermbg"] = ctermbg | endif

    call deline#_highlight(a:hlname, hl)

    return ""
endfunction

"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! deline#defHLBGTransInner(hlname, lhlname, rhlname)
    "no!
    "if get(s:config["_hlonce"], a:hlname, "") == ""
    "    let s:config["_hlonce"][a:hlname] = "*"
    "else
    "    return ""
    "endif

    try
        silent let lhl = deline#_parseHL(a:lhlname)
    catch
        silent let lhl = deline#_parseHL("Normal")
    endtry

    try
        silent let rhl = deline#_parseHL(a:rhlname)
    catch
        silent let rhl = deline#_parseHL("Normal")
    endtry

    let hl = copy(lhl)

    "combine
    let guifg = get(lhl, "guibg", "")
    let ctermfg = get(lhl, "ctermbg", "")
    let guibg = get(rhl, "guibg", "")
    let ctermbg = get(rhl, "ctermbg", "")

    if guibg != "" | let hl["guibg"] = guibg | endif
    if guifg != "" | let hl["guifg"] = guifg | endif
    if ctermbg != "" | let hl["ctermbg"] = ctermbg | endif
    if ctermfg != "" | let hl["ctermfg"] = ctermfg | endif

    call deline#_highlight(a:hlname, hl)

    return ""
endfunction

function! deline#_parseHL(hlname)
    let h = ""
    silent redir => h
    try
        execute "hi " . a:hlname
    catch
        "nop!!!
    finally
        redir END
    endtry

    let h = trim(h)

    if h =~ "="
        "Comment        xxx term=bold ctermfg=16 ctermbg=231 guifg=#bbbbbb guibg=#ffffff
        let hh = substitute(h, '\w\+\s\+\w\+\s\+', '', '')
        "term=bold ctermfg=16 ctermbg=231 guifg=#bbbbbb guibg=#ffffff
        return deline#_parseHLAttrs(hh)
    elseif h =~ "links to"
        "vimComment        xxx links to Comment
        let hh = substitute(h, '.*links to \(\w\+\).*', '\1', "")
        return deline#_parseHL(hh)
    else
        return deline#_parseHL("Normal")
    endif
endfunction

function! deline#_parseHLAttrs(attrs)
    let hh = split(a:attrs, '\%(\\\)\@<!\(\s\|\n\)')
    let hldict = {}
    for c in hh
        let cc = split(c, "=")
        if len(cc) == 2
            let hldict[cc[0]] = cc[1]
        endif
    endfor
    return hldict
endfunction

"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! deline#notsavedInner(min_ago)
    if &modified == 0
        return ""
    endif

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

"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

let s:fileids = {} " url => timer_id
function! deline#head(filepath, enc, interval)
    let id = get(s:fileids, a:filepath, 0)
    if id == 0
        let interval = a:interval
        if interval < 1000
            let interval = 60 * 60 * 1000
        endif

        let id = timer_start(interval, "deline#_read_head", {"repeat": -1})
        let s:fileids[a:filepath] = id
        call deline#_config_set("deline/head/" . string(id) . "/filepath", a:filepath)
        call deline#_config_set("deline/head/" . string(id) . "/enc", a:enc)
        call deline#_read_head(id)
    endif

    return "%{deline#readInner('" . string(id) . "')}"
endfunction

function! deline#tail(filepath, enc, interval)
    let id = get(s:fileids, a:filepath, 0)
    if id == 0
        let interval = a:interval
        if interval < 1000
            let interval = 60 * 60 * 1000
        endif

        let id = timer_start(interval, "deline#_read_tail", {"repeat": -1})
        let s:fileids[a:filepath] = id
        call deline#_config_set("deline/head/" . string(id) . "/filepath", a:filepath)
        call deline#_config_set("deline/head/" . string(id) . "/enc", a:enc)
        call deline#_read_tail(id)
    endif

    return "%{deline#readInner('" . string(id) . "')}"
endfunction

function! deline#readInner(id)
    let line = deline#_config_get("deline/head/" . a:id . "/content", "")
    let enc = deline#_config_get("deline/head/" . a:id . "/enc", "")
    if enc != "" && enc != &encoding && has('iconv')
        let line = iconv(line, enc, &encoding)
    endif
    return line
endfunction

function! deline#_read_head(id)
    let filepath = expand(deline#_config_get("deline/head/" . string(a:id) . "/filepath", ""))
    try
        let line = readfile(filepath, "", 1)
    catch
        let line = [""]
    endtr
    call deline#_config_set("deline/head/" . string(a:id) . "/content", line[0])
endfunction

function! deline#_read_tail(id)
    let filepath = expand(deline#_config_get("deline/head/" . string(a:id) . "/filepath", ""))
    try
        let line = readfile(filepath, "", -1)
    catch
        let line = [""]
    endtr
    call deline#_config_set("deline/head/" . string(a:id) . "/content", trim(line[0]))
endfunction
