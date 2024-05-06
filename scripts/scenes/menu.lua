menu_fs = flow_state:new({
    items = { "level", "test" },
    scores = { nil, nil },
    select = 0,

    begin = function(_ENV)
        flowstates = { level_fs, test_fs }
        select = 0
    end,

    update = function(_ENV)
        if btnp(3) then
            select = select % #items + 1
        elseif btnp(2) then
            select = (select + #items - 2) % #items + 1
        elseif btnp(5) then
            if select > 0 and select <= #flowstates then
                --return level_fs
                return flowstates[select]
            end
        end
    end,

    draw = function(_ENV)
        cls()
        map(16, 0, 0, 0, 16, 16)
        ypos = 12
        xpos = 20
        rectfill(0, 119, 127, 127, 7)

        local txt = "up/down = navigate | x = select"
        print_bold(txt, 2, 121, 12, 0)

        for i = 1, #items do
            --circfill(63,63,10)
            if select == i then
                txt = "" .. items[i] .. " <"
                colour = 12
            else
                txt = "" .. items[i]
                colour = 14
            end

            local x = xpos
            local y = ypos + i * 8
            print_bold(txt, x, y, colour, 0)

            if flowstates[i].high_score != nil then
                txt = "" .. flowstates[i].high_score
                x = 108 - #txt / 2 * 4
                y = ypos + i * 8
                print_bold(txt, x, y, colour, 0)
            end
        end
    end,

    finish = function(_ENV)
    end
})