if !exists("g:Deline_DefaultDefinitions")
    let g:Deline_DefaultDefinitions = 1
endif

call deline#_init()

" Call this function when redefine statusline entirely.
" 
" see below example (default definition).
function! Deline(list)
    call deline#_set(a:list)
endfunction

function! DelineConfig(config)
    call deline#_config(a:config)
endfunction

function! DelineConfigGet(key, defvalue)
    return deline#_config_get(a:key, a:defvalue)
endfunction


if g:Deline_DefaultDefinitions 
    "
    " hi User1 ... textual part (config key "hl_1")
    " hi User2 ... mode (CHANGED IN deline#modeHL,
    "                    config key "hl_mode_" . mode())
    "
    " hi User3 ... seprator (config key "hl_3")
    " hi User4 ... cautious (config key "hl_4")
    "
    call Deline([
                \ deline#comment("mode (define User2 and change to it by hl(2))"),
                \ deline#modeHL("User2"),
                \ deline#hl(2),
                \ deline#space(),
                \ deline#mode(),
                \ deline#space(),
                \ 
                \ deline#comment("filepath and mod, readonly flags"),
                \ deline#hl(1), deline#space(),
                \ deline#hl(4),
                \ deline#readonly('[RO] ', ''),
                \ deline#modified('+ ', ''),
                \
                \ deline#comment("v-- expand(%:p:h:t) / expand(%:p:t)"),
                \ deline#comment("deline#file(':p:h:t/:p:t'),"),
                \ deline#hl(3), deline#file(':p:h:t'), "/",
                \ deline#hl(1), deline#file(':p:t'),
                \ deline#space(),
                \ deline#hl(4), deline#notsaved(2),
                \
                \ deline#rightalign(),
                \
                \ deline#comment("\ deline#fileformat(),"),
                \ deline#dynamic#if("&fileformat!='unix'", deline#hl(4), deline#hl(1)),
                \ deline#fileformat(),
                \ deline#hl(1),
                \
                \ deline#comment("v-- separator"),
                \ deline#space(), deline#hl(3), deline#bar(), deline#hl(1), deline#space(),
                \
                \ deline#comment("\ deline#fileencoding(),"),
                \ deline#dynamic#if("&fileencoding!='utf-8'", deline#hl(4), deline#hl(1)),
                \ deline#fileencoding(),
                \ deline#hl(1),
                \
                \ deline#space(), deline#hl(3), deline#bar(), deline#hl(1), deline#space(),
                \
                \ deline#filetype(),
                \
                \ deline#space(), deline#hl(3), deline#bar(), deline#hl(1), deline#space(),
                \
                \ deline#line(), ":", deline#columnv(),
                \
                \ deline#space(),
                \ ])
                "
                " v-- Display a tail line of a textfile.
                " \ deline#hl(3), "hoge.txt: ", deline#filetail('c:/temp/hoge.txt', 5000),
                "
                " v-- Display searching string if width > 80.
                " \ deline#dynamic#if("winwidth(0) > 80 && !v:hlsearch", 
                "     \ "/" . deline#expr("getreg('/')") .
                "     \ deline#space() . deline#hl(3) . deline#bar() . deline#hl(1) . deline#space(),
                "     \ ""),
                "
                " dynamic#xxx is called on eval-time of statusline
                "
                " v-- This changes highlight according to fileencoding. 
                "     Statusline notation can't do this. (workaround exists, but noisy)
                " \ deline#dynamic#if("&fileencoding!='utf-8'", deline#hl(4), deline#hl(1)),
                "
                " v-- dynamic#periodic turns on timer (ms).
                "     This causes dynanmic#xxx evaluated periodicaly.
                " \ deline#dynamic#periodic(1000),
                " \ deline#dynamic#expr("strftime('%T')"),
                " ^-- dynamic#expr does NOT emit "a RESULT of strftime('%T')" immediately,
                "     but emits "this should return strftime('%T') on
                "     evaluation time".
                "
                " v-- animation
                " \ deline#dynamic#cyclic(['-', '\', '|', '/', '-', '\', '|', '/', '-', '-', '+', '*', '+']),
                " \ deline#dynamic#cyclic(['⣾','⣽','⣻','⢿','⡿','⡿','⣟','⣯','⣷']),

    " call DelineConfig({
    "             \ "no_name": "名無しさん@Vim",
    "             \ })

    " An example usage of DelineConfig
    " call DelineConfig({
    "             \ "mode_c": {
    "             \ "": " COMMAND ",
    "             \ "guifg": "#000000",
    "             \ "guibg": "#ffffff",
    "             \ },
    "             \ })
endif

augroup Deline
autocmd!
autocmd VimEnter * call deline#_initHighlight()
autocmd ColorScheme * let &statusline=&statusline | call deline#_initHighlight()
augroup END
