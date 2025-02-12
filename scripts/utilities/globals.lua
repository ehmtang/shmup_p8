g_scrn = { 128, 128 } -- screen size
g_dt = 0.033          --delta time
g_time = 0            --total time
g_blink = 1           -- txt blink increment

function print_bold(text, x, y)
    print(text, x, y - 1, 7)
    print(text, x - 1, y, 7)
    print(text, x, y + 1, 7)
    print(text, x + 1, y, 7)
    print(text, x, y, 0)
end

function print_bold_r_aligned(text, x, y, text_colour, highlight_colour)
    print(text, x - #text * 4 - 1, y, highlight_colour)
    print(text, x - #text * 4 + 1, y, highlight_colour)
    print(text, x - #text * 4, y - 1, highlight_colour)
    print(text, x - #text * 4, y + 1, highlight_colour)
    print(text, x - #text * 4, y, text_colour)
end

-- returns colour
function blink(fg_col, bg_col)
    local b_anim = {
        fg_col, fg_col, fg_col, fg_col, fg_col, fg_col,
        bg_col, bg_col, bg_col, bg_col, bg_col, bg_col }
    if global.g_blink > #b_anim then
        global.g_blink = 1
    end
    return b_anim[g_blink]
end

function sign(x)
    return x > 0 and 1 or (x < 0 and -1 or 0)
end

function ssqr(x, y)
    return x * x + y * y
end

function norm(x, y)
    local len_sq = ssqr(x, y)
    return len_sq > 0 and (x / sqrt(len_sq)), (y / sqrt(len_sq)) or 0, 0
end

-- Define collision layers using bit flags
LAYER_PLAYER        = 0x01 -- 0001 (bit 0)
LAYER_ENEMY         = 0x02 -- 0010 (bit 1)
LAYER_PLAYER_BULLET = 0x04 -- 0100 (bit 2)
LAYER_ENEMY_BULLET  = 0x08 -- 1000 (bit 3)

function canCollide(objA, objB)
    return (objA.layer & objB.mask) ~= 0 and (objB.layer & objA.mask) ~= 0
end

function circleCollide(a, b)
    local dx = b.pos_x - a.pos_x
    local dy = b.pos_y - a.pos_y
    local dsqr = dx * dx + dy * dy
    local radiusSum = b.rad + a.rad
    return dsqr <= radiusSum * radiusSum
end
