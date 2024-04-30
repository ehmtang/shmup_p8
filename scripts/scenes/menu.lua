menu_fs = flow_state:new({
    items = { "level1",  "level2", "level3", "level4"},
    flowstates = {level1_fs, level2_fs, level3_fs, level4_fs},
    scores={},
    scores= {nil, nil, nil, nil},
    select = 0,
    
    begin = function(_ENV)
        flowstates = {level1_fs, level2_fs, level3_fs, level4_fs}
        select=0
    end,

    update = function(_ENV)
        if btnp(3) then
            select = select % #items + 1
        elseif btnp(2) then
            select = (select + #items-2) % #items + 1
        elseif btnp(5) then
            if (select > 0 and  select<= #flowstates) then
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
        rectfill(0, 119, 127, 127,7)
        local txt = "up/down = navigate | x = select"
        print(txt, 64 - (#txt/2)*4-1, 121, 0)
        print(txt, 64 - (#txt/2)*4+1, 121, 0)
        print(txt, 64 - (#txt/2)*4, 121-1, 0)
        print(txt, 64 - (#txt/2)*4, 121+1, 0)
        print(txt, 64 - (#txt/2)*4, 121, 12)

        for i = 1, #items do
            --circfill(63,63,10)
            if select == i then
                txt=""..items[i].." <"
                col = 12
            else
                txt=""..items[i]
                col = 14
            end
            
            print(items[i], xpos, ypos + i * 8, col)
            local x = xpos
            local y = ypos + i*8
            print(txt, x+1, y, 0)
            print(txt, x-1, y, 0)
            print(txt, x, y+1, 0)
            print(txt, x, y-1, 0)
            print(txt, x, y, col)


            if (flowstates[i].high_score != nil) then
                txt=""..flowstates[i].high_score
                x=108-(#txt/2)*4
                y=ypos+i*8
                print(txt, x+1, y, 0)
                print(txt, x-1, y, 0)
                print(txt, x, y+1, 0)
                print(txt, x, y-1, 0)
                print(txt, x, y, col)
            end
        end
    end,

    finish = function(_ENV)
    end
})