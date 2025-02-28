-- Splash Screen
splash_fs = flowstate:new({
    begin = function(_ENV)
        local n_stars = 50
        local star_types = { star, near_star, far_star }
    
        for i = 1, n_stars do
            local star_type = rnd(star_types)
           star_type:new({ pos_x = rnd(127), pos_y = rnd(127) })
        end
    end,

    update = function(_ENV)

        if btnp(5) then
            return menu_fs
        end

        return nil
    end,

    draw = function(_ENV)
        local txt = "shmup"
        print(txt, 64 - (#txt * 2), 60, blink(7,0))
        txt = "press ❎ to start"
        print(txt, 64 - (#txt * 2), 68, blink(7,0))
        

    end,

    finish = function(_ENV)
    end
})
