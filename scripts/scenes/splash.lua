-- Splash Screen 
splash_fs = flow_state:new({
    select = 0,
    
    begin = function(_ENV)
        flowstates = {splash_fs}
        select=0
    end,

    update = function(_ENV)
        if btnp(5) then
            return menu_fs
        end
    end,

    draw = function(_ENV)
        cls()
        rectfill(0, 119, 127, 127,7)
        print("txt", 64 - 4, 121, 12)
    end,

    finish = function(_ENV)
    end
})