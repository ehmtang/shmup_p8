menu_fs = flow_state:new({
    items = { "level1",  "level2", "level3", "level4"},
    scores= {nil, nil, nil, nil},
    select = 0,
    
    begin = function(_ENV)
        flowstates = {splash_fs}
        select=0
    end,

    update = function(_ENV)
        if btnp(5) then
            return splash_fs
        end
    end,

    draw = function(_ENV)
        cls()
        rectfill(0, 119, 127, 127,7)
        local txt = "press ❎ to start"
        print(txt, 64 - (#txt * 2), 121, 12)
    end,

    finish = function(_ENV)
    end
})