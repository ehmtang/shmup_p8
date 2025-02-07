menu_fs = flow_state:new({
    items = { "level", "test" },
    scores = { nil, nil },
    select = 0,

    begin = function(_ENV)
        flowstates = { level_fs, test_fs }
        select = 0
    end,

    update = function(_ENV)
    end,

    draw = function(_ENV)
        cls()
        map(16, 0, 0, 0, 16, 16)
        ypos = 12
        xpos = 20
        rectfill(0, 119, 127, 127, 7)

        local txt = "up/down = navigate | x = select"
        print_bold(txt, 2, 121, 12, 0)
    end,

    finish = function(_ENV)
    end
})