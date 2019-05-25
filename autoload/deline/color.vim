function! deline#color#attr_to_rgb(attr)
    let cl = a:attr[1:]
    if strlen(cl) == 3
        let r = str2nr(cl[0], 16) * 16 * 1.0
        let g = str2nr(cl[1], 16) * 16 * 1.0
        let b = str2nr(cl[2], 16) * 16 * 1.0
    else
        let r = str2nr(cl[0:1], 16) * 1.0
        let g = str2nr(cl[2:3], 16) * 1.0
        let b = str2nr(cl[4:5], 16) * 1.0
    endif

    return [float2nr(r), float2nr(g), float2nr(b)]
endfunction

function! deline#color#add(attr1, attr2, percent)
    let rgb1 = deline#color#attr_to_rgb(a:attr1)
    let rgb2 = deline#color#attr_to_rgb(a:attr2)

    let r = float2nr(rgb1[0] * (1-a:percent) + rgb2[0]*a:percent + 0.5)
    let g = float2nr(rgb1[1] * (1-a:percent)  + rgb2[1]*a:percent + 0.5)
    let b = float2nr(rgb1[2] * (1-a:percent)  + rgb2[2]*a:percent + 0.5)

    return [r, g, b]
endfunction

function! deline#color#hsv(r, g, b)
    let r = a:r
    let g = a:g
    let b = a:b

    " min float
    let rgbmin = r
    if g < rgbmin | let rgbmin = g | endif
    if b < rgbmin | let rgbmin = b | endif
    " max float
    let rgbmax = r
    if rgbmax < g | let rgbmax = g | endif
    if rgbmax < b | let rgbmax = b | endif

    " H
    if rgbmax == rgbmin
        let h = 0
    elseif r == rgbmax
        echom 'r'
        let h = 60 * ((g - b) / (rgbmax - rgbmin))
    elseif g == rgbmax
        let h = 60 * ((b - r) / (rgbmax - rgbmin)) + 120
    elseif b == rgbmax
        let h = 60 * ((r - g) / (rgbmax - rgbmin)) + 240
    endif
    if h < 0
        let h = h + 360
    endif

    " S
    if rgbmax == 0
        let s = 0
    else
        let s = (rgbmax - rgbmin) / rgbmax * 255
    endif

    " V
    let v = rgbmax

    return [float2nr(h),float2nr(s),float2nr(v)]
endfunction

function! deline#color#rgb(h, s, v)
    let h = a:h
    let s = a:s
    let v = a:v

    let rgbmax = v
    let rgbmin = rgbmax - ((s / 255) * rgbmax)

    if h <= 60
        let r = rgbmax
        let g = (h / 60) * (rgbmax - rgbmin) + rgbmin
        let b = rgbmin
    elseif h <= 120
        let r = ((120 - h) / 60) * (rgbmax - rgbmin) + rgbmin
        let g = rgbmax
        let b = rgbmin
    elseif h <= 180
        let r = rgbmin
        let g = rgbmax
        let b = ((h - 120) / 60) * (rgbmax - rgbmin) + rgbmin
    elseif h <= 240
        let r = rgbmin
        let g = ((240 - h) / 60) * (rgbmax - rgbmin) + rgbmin
        let b = rgbmax
    elseif h <= 300
        let r = ((h - 240) / 60) * (rgbmax - rgbmin) + rgbmin
        let g = rgbmin
        let b = rgbmax
    else
        let r = rgbmax
        let g = rgbmin
        let b = ((360 - h) / 60) * (rgbmax - rgbmin) + rgbmin
    endif

    return [r,g,b]
endfunction
