level_fs = flow_state:new({
    title = "base",
    spawn_rate_0 = 5,
    high_score = 0,

    spawn = function(_ENV)
        local a = 0 -- Ensure 'a' is local if it's not meant to be global
    end,

    begin = function(_ENV)
        -- Initialize player and UI if required
        _ENV:spawn()  -- Uncomment if needed

        player = player_obj:new()
        player:init()

        --ui_obj:init()  -- Uncomment if `ui_obj` needs initialization
    end,

    update = function(_ENV)
        player:update()
    end,

    draw = function(_ENV)
        rectfill(0, 0, 127, 127, 1)
        --ui_obj:draw()
        player:draw()

        
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
