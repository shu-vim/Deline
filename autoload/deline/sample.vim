function! deline#sample#simple()
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

    call deline#_apply()
endfunction

function! deline#sample#glass()
    call Deline([
                \ deline#defHLCombined("DelineHL", "", "Normal", "StatusLine", "fg/fg+bg3"),
                \ deline#defHLMode("DelineHLMode_tmp"),
                \ deline#defHLCombined("DelineHLMode", "mode()", "DelineHLMode_tmp", "DelineHL", "fg/fg+bg3"),
                \ deline#defHLCombined("DelineHLRight", "", "DelineHL", "DelineHL", ""),
                \ deline#defHLCombined("DelineHLRight2", "", "DelineHL", "DelineHL", ""),
                \
                \ deline#defHLCombined("DelineHLLeft", "mode()", "DelineHL", "DelineHLMode", "fg/fg+bg3"),
                \ deline#defHLCombined("DelineHLAlert", "", "guifg=#ff0000 ctermfg=Red", "DelineHL", ""),
                \ 
                \ deline#comment("* MODE *"),
                \ deline#hl("DelineHLMode"),
                \ deline#space(),
                \ deline#mode(),
                \ deline#space(),
                \ 
                \ deline#comment("* filepath/filename *"),
                \ deline#hl("DelineHLLeft"),
                \ deline#space(),
                \ deline#readonly("[RO] ", ''),
                \ deline#defHLCombined("DelineHLPath", "mode()", "guifg=#777777 ctermfg=LightGray", "DelineHLLeft", ""),
                \ deline#defHLAdjFG("DelineHLPath", "mode().'*'"),
                \ deline#hl("DelineHLPath"), deline#file(':p:h:t'), "/",
                \ deline#hl("DelineHLLeft"), deline#file(':p:t'),
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

    call deline#_apply()
endfunction

function! deline#sample#powerful()
    call deline#_config_set("interval", 60)
    call Deline([
                \ deline#defHLCombined("DelineHL", "", "StatusLine", "StatusLine", ""),
                \ deline#defHLMode("DelineHLMode_tmp"),
                \ deline#defHLCombined("DelineHLMode", "mode()", "DelineHL", "DelineHLMode_tmp", "fg/fg+bg9"),
                \
                \ deline#defHLCombined("DelineHLLeft", "mode()", "DelineHL", "DelineHLMode", "fg/fg+bg"),
                \ deline#defHLSeparator("DelineHLLeftSep", "mode()", "DelineHLLeft", "DelineHL"),
                \ deline#defHLCombined("DelineHLAlert", "", "guifg=#ff0000 ctermfg=Red", "DelineHL", ""),
                \ 
                \ deline#comment("* MODE *"),
                \ deline#hl("DelineHLMode"),
                \ deline#space(),
                \ deline#mode(),
                \ deline#space(),
                \
                \ deline#comment("* MODE->Normal *"),
                \ deline#defHLSeparator("DelineHLModeSep", "mode()", "DelineHLMode", "DelineHLLeft"),
                \ deline#hl("DelineHLModeSep"),
                \ "\ue0b0",
                \ 
                \ deline#comment("* branch *"),
                \ deline#hl("DelineHLLeft"),
                \ deline#sample#powerful_branch(),
                \ deline#space(),
                \ 
                \ deline#comment("* filepath/filename *"),
                \ deline#defHLCombined("DelineHLPath", "mode()", "guifg=#777777 ctermfg=LightGray", "DelineHLLeft", ""),
                \ deline#readonly("\ue0a2", ''),
                \ deline#hl("DelineHLPath"), deline#file(':p:h:t'), "/",
                \ deline#hl("DelineHLLeft"), deline#file(':p:t'),
                \ deline#space(),
                \
                \ deline#hl("DelineHLLeftSep"),
                \ "\ue0b0",
                \ 
                \ deline#hl("DelineHL"),
                \ 
                \ deline#rightalign(),
                \ 
                \ deline#comment("* fileformat(dos/unix) *"),
                \ deline#comment("\ deline#fileformat(),"),
                \ deline#dynamic#if("&fileformat!='unix'", deline#hl("DelineHLAlert"), deline#hl("DelineHL")),
                \ deline#fileformat(),
                \
                \ "\ue0b3",
                \
                \ deline#comment("* fileencoding *"),
                \ deline#space(),
                \ deline#dynamic#if("&fileencoding!='utf-8'", deline#hl("DelineHLAlert"), deline#hl("DelineHL")),
                \ deline#fileencoding(),
                \
                \ "\ue0b3",
                \
                \ deline#comment("* filetype *"),
                \ deline#space(),
                \ deline#filetype(),
                \
                \ "\ue0b3",
                \ 
                \ deline#comment("* position *"),
                \ deline#space(),
                \ deline#line(), ":", deline#columnv(),
                \
                \ deline#space(),
                \ ])

    call deline#_apply()
endfunction

function! deline#sample#powerful_branch()
    let d = {}
    function! d.eval() dict
        try
            let resp = trim(system("git branch"))
            if v:shell_error == 0
                let resp = resp[2:]
            else
                let resp = trim(system("hg branch"))
                if v:shell_error != 0
                    return ""
                endif
            endif
            if resp != ""
                return "\ue0a0" . resp . " \ue0b1"
            endif
        catch
            return ""
        endtry
    endfunction
    return d
endfunction

function! deline#sample#distinctive()
        call Deline([
            \ deline#comment('deline#defHL("DelineHL", "", "guifg=#cccccc guibg=#333333 ctermfg=White ctermbg=DarkGray"),'),
            \ deline#defHLCombined("DelineHL", "", "StatusLine", "StatusLine", ""),
            \ deline#defHLMode("DelineHLMode"),
            \ deline#defHLSeparator("DelineHLModeSep", "mode()", "DelineHLMode", "DelineHL"),
            \ deline#defHLCombined("DelineHLName", "", "DelineHL", "DelineHL", ""),
            \ deline#defHLCombined("DelineHLPath", "", "guifg=#777777 ctermfg=LightGray", "DelineHL", ""),
            \ deline#defHLCombined("DelineHLAlert", "","guifg=#ffbbbb ctermfg=DarkRed", "DelineHL", ""),
            \ deline#defHLSeparator("DelineHLSep", "", "DelineHL", "Normal"),
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
            \ deline#defHLInv("DelineHL2", "", "DelineHL"),
            \ deline#defHLCombined("DelineHL2SepMini", "", "", "DelineHL2", ""),
            \ deline#defHLCombined("DelineHL2Alert", "", "guifg=#aa0000 ctermfg=DarkRed", "DelineHL2", ""),
            \ deline#defHLSeparator("DelineHLSep2", "", "DelineHL2", "DelineHL"),
            \ deline#defHLSeparator("DelineHLSep2Inv", "", "DelineHL", "DelineHL2"),
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
            \ deline#space(),
            \ deline#comment("\ deline#fileformat(),"),
            \ deline#dynamic#if("&fileformat!='unix'", deline#hl("DelineHLAlert"), deline#hl("DelineHL")),
            \ deline#fileformat(),
            \
            \ deline#comment("v-- separator"),
            \ deline#comment('\ deline#space(), deline#hl(3), "\ue0b3", deline#hl(1), deline#space(),'),
            \ deline#space(),
            \ deline#hl("DelineHLSep2"),
            \ "\ue0b2",
            \ deline#hl("DelineHL2"),
            \ deline#space(),
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

    call deline#_apply()
endfunction
