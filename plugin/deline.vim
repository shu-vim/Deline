if !exists("g:Deline_DefaultDefinitions")
    """if non-zero, define statusline by deline's settings.
    let g:Deline_DefaultDefinitions = 1
endif

if !exists("g:Deline_Powerful")
    """if non-zero, define statusline by deline's powerful settings.
    let g:Deline_Powerful = 0
endif

call deline#_init()

"""Define |'statusline'| with |deline-functions|.
"""
"""Example: >
"""    call Deline([
"""        \ "mode:",
"""        \ deline#mode(),
"""        \ deline#rightalign(),
"""        \ deline#modified('+ ', ''),
"""        \ deline#file(':p:h:t/:p:t'),
"""        \ ])
"""<
"""    ______________________________________ 
"""    mode:NORMAL         + mydir/myfile.txt 
"""    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
function! Deline(list)
    call deline#_set(a:list)
endfunction

"""Configure Deline settings.
"""
"""Example: >
"""    call DelineConfig({
"""        \ "no_name": "*NAME_NOT_DEFINED*",
"""        \
"""        \ "mode_c": {
"""        \ "": " COMMAND ",
"""        \ "guifg": "#000000",
"""        \ "guibg": "#ffffff",
"""        \ },
"""        \ })
"""<
"""
"""KEY		DESCRIPTION ~
"""
"""hl_1		highlight group User1: textual part
"""hl_3		highlight group User3: separator
"""hl_4		highlight group User4: cautious
"""hl_mode_	highlight group User2: mode `"hl_mode_" . mode()`
"""no_name		fallback name of |deline#file()|
"""		default: [No Name]
"""interval	throttling interval of re-evaluating of
"""		dynamic functions in second.
"""		default: 0.5
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
                \ deline#defHLMode("User2"),
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

    if g:Deline_Powerful
        try
            silent call Deline([
                \ deline#defHL("DelineHL", "guifg=#cccccc guibg=#333333 ctermfg=White ctermbg=DarkGray"),
                \ deline#defHLMode("DelineHLMode"),
                \ deline#defHLBGTrans("DelineHLModeSep", "DelineHLMode", "DelineHL"),
                \ deline#defHLCombined("DelineHLName", "DelineHL", "DelineHL"),
                \ deline#defHLCombined("DelineHLPath", "guifg=#777777 ctermfg=LightGray", "DelineHL"),
                \ deline#defHLCombined("DelineHLAlert","guifg=#ffbbbb ctermfg=DarkRed", "DelineHL"),
                \ deline#defHLBGTrans("DelineHLSep", "DelineHL", "Normal"),
                \ 
                \ deline#hl("DelineHLMode"),
                \ deline#space(),
                \ deline#mode(),
                \ deline#space(),
                \ deline#hl("DelineHLModeSep"),
                \ "\ue0b0",
                \
                \ deline#comment("filepath and mod, readonly flags"),
                \ deline#hl("DelineHLName"),
                \ deline#space(),
                \ deline#readonly("\U1f512 \ue0b1 ", ''),
                \
                \ deline#comment("v-- expand(%:p:h:t) / expand(%:p:t)"),
                \ deline#comment("deline#file(':p:h:t/:p:t'),"),
                \ deline#hl("DelineHLPath"), deline#file(':p:h:t'), "/",
                \ deline#hl("DelineHLName"), deline#file(':p:t'),
                \ deline#space(),
                \ deline#hl("DelineHLAlert"),
                \ deline#modified("\ue0b1 + ", ''),
                \ deline#hl("DelineHLAlert"), deline#notsaved(2),
                \ deline#space(),
                \
                \ deline#hl("DelineHLSep"),
                \ "\ue0b0",
                \
                \ deline#rightalign(),
                \
                \ deline#defHLCombined("DelineHL2", "Normal", "Normal"),
                \ deline#defHLCombined("DelineHL2SepMini", "","DelineHL2"),
                \ deline#defHLCombined("DelineHL2Alert", "guifg=#ffbbbb ctermfg=DarkRed", "DelineHL2"),
                \ deline#defHLBGTrans("DelineHLSep2", "DelineHL2", "DelineHL"),
                \ deline#defHLBGTrans("DelineHLSep2Inv", "DelineHL", "DelineHL2"),
                \
                \ deline#hl("DelineHLSep"),
                \ "\ue0b2",
                \
                \ deline#hl("DelineHL"),
                \ deline#space(),
                \ "\U1F4C4", deline#comment("page icon"),
                \
                \ deline#dynamic#if("winwidth(0) > 80", 
                    \ deline#hl("DelineHLSep2") .
                    \ "\ue0b2" .
                    \ deline#hl("DelineHL2") .
                    \
                    \ deline#comment('\ deline#space() . "\ue0b3" . deline#space() .') .
                    \
                    \ deline#space().
                    \ deline#expr("strftime('%T')") .
                    \
                    \ deline#space().
                    \ deline#hl("DelineHLSep2Inv").
                    \ "\ue0b2".
                    \ deline#hl("DelineHL").
                    \ deline#space(),
                    \ deline#space()),
                \
                \ deline#comment("\ deline#fileformat(),"),
                \ deline#dynamic#if("&fileformat!='unix'", deline#hl(4), deline#hl(1)),
                \ deline#fileformat(),
                \
                \ deline#comment("v-- separator"),
                \ deline#comment('\ deline#space(), deline#hl(3), "\ue0b3", deline#hl(1), deline#space(),'),
                \ deline#space(),
                \ deline#hl("DelineHLSep2"),
                \ "\ue0b2",
                \ deline#hl("DelineHL2"),
                \ deline#space(),
                \
                \ deline#comment("\ deline#fileencoding(),"),
                \ deline#dynamic#if("&fileencoding!='utf-8'", deline#hl("DelineHL2Alert"), deline#hl("DelineHL2")),
                \ deline#fileencoding(),
                \
                \ deline#comment('\ deline#space(), deline#hl(3), "\ue0b3", deline#hl(1), deline#space(),'),
                \ deline#space(),
                \ deline#hl("DelineHLSep2Inv"),
                \ "\ue0b2",
                \ deline#hl("DelineHL"),
                \ deline#space(),
                \
                \ deline#filetype(),
                \
                \ deline#comment('\ deline#space(), deline#hl(3), "\ue0b3", deline#hl(1), deline#space(),'),
                \ deline#space(),
                \ deline#hl("DelineHLSep2"),
                \ "\ue0b2",
                \ deline#hl("DelineHL2"),
                \ deline#space(),
                \
                \ deline#line(), ":", deline#columnv(),
                \
                \ deline#space(),
                \ ])
        catch
        endtry
    endif
endif

augroup Deline
autocmd!
autocmd VimEnter * call deline#_initHighlight()
autocmd BufEnter,ColorScheme * call deline#_apply() | call deline#_initHighlight()
augroup END
