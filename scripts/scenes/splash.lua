-- Splash Screen
splash_fs = flowstate:new({
    begin = function(_ENV)
        local STAR_COUNT = 50

        score = 0
        stars = {}
        star_types = { star, near_star, far_star }
    
        for i = 1, STAR_COUNT do
            local star_type = rnd(star_types)
            add(g_obj_manager.g_objs, star_type:new({ x = rnd(127), y = rnd(127) }))
        end
    end,

    update = function(_ENV)
        foreach(g_obj_manager.g_objs, function(star) star:update() end)
        if btnp(5) then
            return menu_fs
        end

        return nil
    end,

    draw = function(_ENV)
        foreach(g_obj_manager.g_objs, function(star) star:draw() end)
        print("score: " .. score, 8, 8, 7)

        local txt = "splash screen"
        print(txt, 64 - (#txt * 2), 60, 12)
        txt = "press ❎ to start"
        print(txt, 64 - (#txt * 2), 68, 12)
        

    end,

    finish = function(_ENV)
    end
})
