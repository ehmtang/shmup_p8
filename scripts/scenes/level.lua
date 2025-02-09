level_fs = flow_state:new({
    title = "base",
    spawn_rate_0 = 5,
    high_score = 0,

    spawn = function(_ENV)
        local a = 0
    end,

    begin = function(_ENV)
        -- Initialize player and UI if required
        _ENV:spawn()
        --player = player_obj:new()
        --player:init()
    end,

    update = function(_ENV)
        g_obj_manager:update()
    end,

    draw = function(_ENV)
        rectfill(0, 0, 127, 127, 1)
        g_obj_manager:draw()


        -- for i, v in ipairs(g_obj_manager.g_objs) do
        --     print(i..': '..v.name,7)
        --   end

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
