LVL_ENTER = 0
LVL_PLAY = 1

level_fs = flowstate:new({
    title = "base",
    player = player_obj:new(),
    spawn_rate_0 = 5,
    score = 0,
    n_wave = 1,
    state = LVL_ENTER,
    enter_time = 0,
    wave_queue = {},
    timer_between_waves = 0,
    wave_queue_idx = 0,

    enemies = {},

    add_wave = function(_ENV, x, y, rows, cols, type)
        add(wave_queue, { x, y, rows, cols, type })
    end,

    spawn_wave = function(_ENV, x0, y0, row, col, type)
        if type == enemy_obj then
            for i = 1, row, 1 do
                for j = 1, col, 1 do
                    x = x0 + j * 10
                    y = y0 + i * 10
                    enemy = enemy_obj:new({ pos_x = x, pos_y = y, n_wave = n_wave })
                    add(enemies, enemy)
                    add(g_obj_manager.g_objs, enemy)
                end
            end
        elseif type == enemyBoss_obj then
            enemy = enemyBoss_obj:new({ pos_x = x0, pos_y = y0, n_wave = n_wave })
            add(enemies, enemy)
            add(g_obj_manager.g_objs, enemy)
        end
    end,


    generate_wave_queue = function(_ENV)
        -- Add different waves
        _ENV:add_wave(64, 10, 0, 0, enemyBoss_obj)
        -- _ENV:add_wave(10, 10, 3, 3, enemy_obj)
        -- _ENV:add_wave(20, 20, 4, 4, enemy_obj)
        -- _ENV:add_wave(30, 30, 5, 5, enemy_obj)
    end,

    is_ready_for_next_queue = function(_ENV)
        for obj in all(enemies) do
            if obj.active then
                return false
            end
        end
        return true
    end,

    begin = function(_ENV)
        -- Initialize player and UI if required
        state = LVL_ENTER
        add(g_obj_manager.g_objs, player)
        player:init()
    end,

    update = function(_ENV)
        -- Enter state: Wait before starting waves
        if state == LVL_ENTER then
            enter_time += g_dt

            -- Move to play state after 3 seconds
            if enter_time > 3 then
                enter_time = 0
                state = LVL_PLAY
                _ENV:generate_wave_queue()
            end


            -- Play state: Spawn waves at intervals
        elseif state == LVL_PLAY then
            timer_between_waves += g_dt

            -- Check if all waves have been spawned
            if wave_queue_idx >= #wave_queue and _ENV:is_ready_for_next_queue() then
                n_wave += 1
                state = LVL_ENTER
                wave_queue = {}    -- Clear previous wave queue
                wave_queue_idx = 0 -- Reset index
                return
            elseif _ENV:is_ready_for_next_queue() then
                wave_queue_idx += 1
                local wave_desc = wave_queue[wave_queue_idx]
                _ENV:spawn_wave(wave_desc[1], wave_desc[2], wave_desc[3], wave_desc[4], wave_desc[5])
            end

            -- Go to Game Over flowstate
            if player.lives <= 0 then
                n_wave = 1
                state = LVL_ENTER
                enter_time = 0
                wave_queue = {}
                timer_between_waves = 0
                wave_queue_idx = 0
                enemies = {}

                player.active = false
                return gameover_fs
            end
        end
    end,

    draw = function(_ENV)
        -- Enter state: Draw wave number
        if state == LVL_ENTER then
            txt = "wave " .. n_wave
            print(txt, 64 - (#txt * 2), 40, blink(7, 0))

            -- Play state: Draw
        elseif state == LVL_PLAY then

        end

        -- Draw regardless of state
        print("score: " .. level_fs.score, 1, 1, 7)

        for i = 1, 4 do
            if level_fs.player.lives >= i then
                spr(level_fs.player.full_heart_spr, g_scrn[1] - i * 9, 1)
            else
                spr(level_fs.player.empty_heart_spr, g_scrn[1] - i * 9, 1)
            end
        end
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
