-- Splash Screen
splash_fs = flow_state:new({
    select = 0,

    begin = function(_ENV)
        flowstates = { splash_fs }
        select = 0
    end,

    update = function(_ENV)
        if btnp(5) then
            return menu_fs
        end
    end,

    draw = function(_ENV)
        --cls()

        -- fill the center 96x96 portion of the screen
        rectfill(16, 16, 111, 111, 1)

        -- Print centered text in color 12
        local txt = "splash screen"
        print(txt, 64 - (#txt * 2), 60, 12)

        -- Print centered text in color 12
        txt = "press ❎ to start"
        print(txt, 64 - (#txt * 2), 68, 12)
    end,

    finish = function(_ENV)
    end
})
