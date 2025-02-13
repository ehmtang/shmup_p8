level_fs = flowstate:new({
    title = "base",
    player = player_obj:new(),
    spawn_rate_0 = 5,
    score = 0,

    spawn_wave = function(_ENV, x0, y0, row, col)
        for i = 1, row, 1 do
            x = x0 + i * 10
            for j = 1, col, 1 do
                y = y0 + j * 10
                add(g_obj_manager.g_objs, enemy_obj:new({ pos_x = x, pos_y = y }))
            end
        end
    end,

    begin = function(_ENV)
        -- Initialize player and UI if required
        _ENV:spawn_wave(60, 10, 4, 1)
        add(g_obj_manager.g_objs, player)
        player:init()
    end,

    update = function(_ENV)
        if player.lives <= 0 then
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
