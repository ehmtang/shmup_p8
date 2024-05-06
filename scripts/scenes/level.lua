elapsed_time = 0.033

level_fs = flow_state:new({
    elevator_doors = { { 1, 2, 3, 4 }, { 1, 2, 3 }, { 1, 2, 3 }, { 1, 2, 3, 4 } },
    allowed_targets = { { 2 }, { 1, 3 }, { 2, 4 }, { 3 } },
    spawn_rate_0 = 5,
    spawn_rate_increase_per_wave = 0.0,
    cat_rate_0 = 1,
    cat_rate_increase_per_wave = 0.0,
    time_per_wave = 10.0,
    time_per_cat_wave = 20.0,
    title = "level",
    next_fs = menu_fs,
    high_score = 0,
    level_time = 0.0,
    spawn_time = 0.0,
    cat_time = 0.0,
    cat_rate = 0,
    spawn_rate = 0,
    customers = {},
    elevators = {},
    z_timer = 0.0,

    spawn = function(_ENV)
        for i = 1, flr(spawn_rate) do
            local new_cust = customer:new()
            new_cust:init(elevators, allowed_targets)
            add(customers, new_cust, i)
        end
    end,

    spawn_cat = function(_ENV)
        for i = 1, flr(cat_rate) do
            local new_cat = cat_obj:new()
            new_cat:init(elevators, allowed_targets)
            add(customers, new_cat, i)
        end
    end,

    begin = function(_ENV)
        level_time = 0.0
        spawn_time = 0.0
        cat_time = 0.0
        customers = {}
        elevators = {}
        cat_rate = cat_rate_0
        spawn_rate = spawn_rate_0

        state = "intro"

        local x0 = 16
        local spacing_x = 24

        for i = 1, 4 do
            local new_elevator = elevator_obj:new()
            new_elevator:init(x0 + (i - 1) * spacing_x, elevator_doors[i], 95 + 2 * i)
            add(elevators, new_elevator, i)
        end

        --customer
        _ENV:spawn()
        _ENV:spawn_cat()

        --player
        player = player_obj:new()
        player:init(elevators)

        ui_obj:init()
    end,

    update = function(_ENV)
        --hold z for 5 seconds to end game
        if btn(4) then
            z_timer += elapsed_time
        else
            z_timer = 0
        end

        -- game over
        if state != "gameover" then
            if ui_obj.rage >= ui_obj.max_rage or z_timer > 5.0 then
                if high_score < ui_obj.total_score then
                    high_score = ui_obj.total_score
                end
                state = "gameover"
            end
        end

        if state == "gameover" then
            if btnp(5) then
                if ui_obj.total_score > high_score then
                    high_score = ui_obj.total_score
                end
                return menu_fs
            end
        elseif state == "intro" then
            if btnp(5) then
                state = "run"
            end
        elseif state == "run" then
            level_time += elapsed_time
            spawn_time += elapsed_time
            cat_time += elapsed_time

            if ui_obj.rage >= ui_obj.max_rage then
                return menu_fs
            end

            if spawn_time > time_per_wave then
                _ENV:spawn()
                spawn_time -= time_per_wave
                spawn_rate += spawn_rate_increase_per_wave
            end

            if cat_time > time_per_cat_wave then
                _ENV:spawn_cat()
                cat_time -= time_per_cat_wave
                cat_rate += cat_rate_increase_per_wave
            end

            -- if (level_time>level_max_time) then
            --     return next_fs
            -- end

            -- game over
            if ui_obj.rage >= ui_obj.max_rage or z_timer > 5.0 then
                if high_score < ui_obj.total_score then
                    high_score = ui_obj.total_score
                end
                state = "gameover"
            end

            --customer
            local c = #customers
            i = 1
            while i <= c do
                customers[i]:update()
                if customers[i].state == "success" then
                    deli(customers, i)
                    i = i - 1
                    c = c - 1
                end
                i = i + 1
            end

            --elevator
            for i = 1, #elevators do
                elevators[i]:update()
            end

            --player
            player:update()

            ui_obj:update()
        end
    end,

    draw = function(_ENV)
        cls()
        map(0, 0, 0, 0, 16, 16)

        for i = 1, #customers do
            customers[i]:draw()
        end

        --elevator
        for i = 1, #elevators do
            elevators[i]:draw()
        end

        for i = 1, #customers do
            customers[i]:draw()
        end
        ui_obj:draw()

        if state == "run" then
            --player
            player:draw()

            --customer
        elseif state == "intro" then
            _ENV:draw_window(6)
            local x0 = 32
            _ENV:magic_print("" .. title, x0 + 0, 7, false)
            _ENV:magic_print("high score : " .. high_score, x0 + 30, 2, true)
            _ENV:magic_print("press (x) to start", x0 + 62, 12, false)

            --⬅️➡️⬆️⬇️ ❎🅾️

            --_ENV:magic_print()
        elseif state == "gameover" then
            _ENV:draw_window(1)
            local txt = "game over!"
            _ENV:magic_print(txt, 40, 8, true)

            local txt = "score : " .. ui_obj.total_score
            _ENV:magic_print(txt, 58, 7, true)

            txt = "high score : " .. high_score
            _ENV:magic_print(txt, 70, 2, true)

            txt = "x = return to menu"
            _ENV:magic_print(txt, 90, 12, true)
            -- local txt = "score : "..total_score
            -- print(txt, 64-(#txt/2)*4 ,62, 7)
        end
    end,

    finish = function(_ENV)
        level_time = 0.0
        spawn_time = 0.0
        customers = {}
        elevators = {}
    end,

    draw_window = function(_ENV, colour)
        local x0 = 24
        local y0 = 127 - x0
        rectfill(x0 + 0, x0 + 0, y0, y0, 0)
        rectfill(x0 + 1, x0 + 1, y0 - 1, y0 - 1, 7)
        rectfill(x0 + 2, x0 + 2, y0 - 2, y0 - 2, 0)
        rectfill(x0 + 3, x0 + 3, y0 - 3, y0 - 3, colour)
    end,

    magic_print = function(_ENV, text, y, colour, float)
        local i = 0

        if float then
            f = 1
        else
            f = 0
        end

        for l in all(text) do
            local x = 64 - #text / 2 * 4 + i * 4
            local y = y + sin(time() * 1.0 - i * 0.2 * f) * 1.0
            print(l, x, y - 1, 0)
            print(l, x, y + 1, 0)
            print(l, x - 1, y, 0)
            print(l, x + 1, y, 0)
            print(l, x, y, colour)
            i += 1
        end
    end
})