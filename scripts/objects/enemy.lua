enemy_obj = game_object:new({
    sprite_id = 2,
    pos_x = 64,
    pos_y = 80,
    vel_x = 0,
    vel_y = 0,
    acc_x = 0,
    acc_y = 0,
    frame = 0,
    frame_pos = 0,
    anim_speed = 0,
    nframes = 0,
    name = "enemy",
    active = true,
    
    max_vel = 1,

    vel_decay = 0.05,
    acc_decay = 0.1,

    fire_time = 0,
    fire_rate = 0.3,

    layer = LAYER_ENEMY, 
    mask = LAYER_PLAYER | LAYER_PLAYER_BULLET,

    init = function(_ENV)

    end,

    update = function(_ENV)
        _ENV:player_ctrls()
        _ENV:bound_player()

        fire_time += g_dt

        -- Apply velocity decay when no input is given
        if not (btn(0) or btn(1)) then
            vel_x -= vel_decay * sign(vel_x)
            if abs(vel_x) < 0.01 then
                vel_x = 0
            end
        end
        if not (btn(2) or btn(3)) then
            vel_y -= vel_decay * sign(vel_y)
            if abs(vel_y) < 0.01 then
                vel_y = 0
            end
        end

        -- clamp velocities
        if ssqr(vel_x, vel_y) > max_vel * max_vel then
            local nvel_x, nvel_y = norm(vel_x, vel_y)
            vel_x = nvel_x * max_vel
            vel_y = nvel_y * max_vel
        end

        muzzle_r -=1
        muzzle_r = mid(0, muzzle_r, muzzle_rmax)

        vel_x += acc_x
        vel_y += acc_y
        pos_x += vel_x
        pos_y += vel_y
    end,

    draw = function(_ENV)
        -- set left, right and idle sprites
        if btn(0) then
            sprite_id = 1
        elseif btn(1) then
            sprite_id = 3
        else
            sprite_id = 2
        end

        -- exhaust animation
        exh_frame_pos += exh_anim_spd
        if (exh_frame_pos > 1) then
            exh_frame += 1
            exh_frame_pos -= 1

            if exh_frame >= exh_nframes then
                exh_frame = 0
            end
        end
        spr(exh_spr_id + exh_frame, pos_x, pos_y + 8)

        
        spr(sprite_id + frame, pos_x, pos_y)

        -- muzzle flash
        if muzzle_r ~= 0 then
            circfill(pos_x + 3, pos_y - 1, muzzle_r, 7)
        end
    end,

    player_ctrls = function(_ENV)
        if btn(0) then
            acc_x = -1 -- Move left
        elseif btn(1) then
            acc_x = 1  -- Move right
        else
            acc_x = 0
        end

        if btn(2) then
            acc_y = -1 -- Move up
        elseif btn(3) then
            acc_y = 1  -- Move down
        else
            acc_y = 0
        end

        if btn(4) then
            if fire_time > fire_rate then
                _ENV:shoot_bullet()
            end
        end
    end,

    shoot_bullet = function(_ENV)
        sfx(0)
        add(g_obj_manager.g_objs, bullet_obj:new({pos_x = pos_x, pos_y = pos_y - 2}))
        muzzle_r = muzzle_rmax
        fire_time = 0
    end,

    bound_player = function(_ENV)
        pos_x = mid(0, pos_x, g_scrn[1]-8)
        pos_y = mid(0, pos_y, g_scrn[2]-8)
    end,
})
