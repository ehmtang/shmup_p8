level_fs = flowstate:new({
    title = "base",
    player = player_obj:new(),
    spawn_rate_0 = 5,
    score = 0,

    spawn = function(_ENV)
        local a = 0
    end,

    begin = function(_ENV)
        -- Initialize player and UI if required
        _ENV:spawn()
        add(g_obj_manager.g_objs, player)
        player:init()
    end,

    update = function(_ENV)
        
        if btn(4) and btn(5) then
            player.active = false
            return gameover_fs    
        end

        if player.lives == 0 then
            player.active = false
            return gameover_fs
        end

        g_obj_manager:update()
    end,

    draw = function(_ENV)
        g_obj_manager:draw()
    end
})

easy_fs = level_fs:new({
    title = "easy",
    high_score = 0,
})

normal_fs = level_fs:new({
    title = "normal",
    high_score = 0,

})

hard_fs = level_fs:new({
    title = "hard",
    high_score = 0,

})
