-- Splash Screen
gameover_fs = flowstate:new({
    begin = function(_ENV)
 
    end,

    update = function(_ENV)
        if btnp(5) then
            return menu_fs
        end

        return nil
    end,

    draw = function(_ENV)
        local txt = "g a m e  o v e r"
        print_bold(txt, 64 - (#txt * 2), 60)
        txt = "press ❎ to start"
        print(txt, 64 - (#txt * 2), 68, 12)
        

    end,

    finish = function(_ENV)
    end
})
