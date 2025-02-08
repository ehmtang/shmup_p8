g_screen_width = 128;
g_screen_height = 128;
g_elapsed_time = 0.033

--print text with highlights one pixel to the left, right, top and bottom
function print_bold(text, x, y, text_colour, highlight_colour)
    print(text, x - 1, y, highlight_colour)
    print(text, x + 1, y, highlight_colour)
    print(text, x, y - 1, highlight_colour)
    print(text, x, y + 1, highlight_colour)
    print(text, x, y, text_colour)
end

function print_bold_r_aligned(text, x, y, text_colour, highlight_colour)
    print(text, x - #text * 4 - 1, y, highlight_colour)
    print(text, x - #text * 4 + 1, y, highlight_colour)
    print(text, x - #text * 4, y - 1, highlight_colour)
    print(text, x - #text * 4, y + 1, highlight_colour)
    print(text, x - #text * 4, y, text_colour)
end

function sign(x) 
    return x > 0 and 1 or (x < 0 and -1 or 0)
end

function ssqr(x, y) 
    return x*x + y*y
end

function norm(x, y)
    local len_sq = ssqr(x, y)
    return len_sq > 0 and (x / sqrt(len_sq)), (y / sqrt(len_sq)) or 0, 0
end