player_obj = g_obj:new({
    max_vel = 2,

    init = function(_ENV)
        sprite_id = 1
        pos_x = 0
        pos_y = 0
        vel_x = 0
        vel_y = 0
        acc_x = 0
        acc_y = 0
        --pos_y = floory[current_elevator.current_floor_idx]
    end,

    update = function(_ENV)
        _ENV:player_ctrls()
        _ENV:bound_player()
        g_obj.update(_ENV)
    end,

    draw = function(_ENV)
        g_obj.draw(_ENV)
    end,

    player_ctrls = function(_ENV)
        if btn(0) then
            pos_x -= 1 -- Move left
        elseif btn(1) then
            pos_x += 1 -- Move right
        end

        if btn(2) then
            pos_y -= 1 -- Move up
        elseif btn(3) then
            pos_y += 1 -- Move down
        end

        if btn(4) then

        end
    end,

    bound_player = function(_ENV)
        if pos_x > 120 then
            pos_x = 120
        elseif pos_x < 0 then
            pos_x = 0
        end

        if pos_y > 120 then
            pos_y = 120
        elseif pos_y < 0 then
            pos_y = 0
        end
    end

})
