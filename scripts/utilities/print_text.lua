--print text with highlights one pixel to the left, right, top and bottom
function print_bold(text, x, y, text_colour, highlight_colour)
    print(text, x - 1, y, highlight_colour)
    print(text, x + 1, y, highlight_colour)
    print(text, x, y - 1, highlight_colour)
    print(text, x, y + 1, highlight_colour)
    print(text, x, y, text_colour)
end

function print_bold_r_aligned(text, x, y, text_colour, highlight_colour)
    print(text, x - #text*4 - 1, y, highlight_colour)
    print(text, x - #text*4 + 1, y, highlight_colour)
    print(text, x - #text*4, y - 1, highlight_colour)
    print(text, x - #text*4, y + 1, highlight_colour)
    print(text, x - #text*4, y, text_colour)
end

function print_magic(text, x, y, text_colour, highlight_colour)
end