player_obj = game_object:new({
    max_spd = 2,

    acc_rate = 0.2,

    fire_time = 0,
    fire_period = 0.2,

    exh_spr_id = 5,
    exh_anim_spd = 0.8,
    exh_frame = 0,
    exh_frame_pos = 0,
    exh_nframes = 5,

    muzzle_r = 0,
    muzzle_rmax = 5,

    lives = 4,
    full_heart_spr = 14,
    empty_heart_spr = 15,

    is_hit = false,
    invulerable_time = 30,

    init = function(_ENV)
        game_object:init()
        spr_id = 2
        pos_x = 64
        pos_y = 80
        name = "player"
        rad = 10
        spr_w = 8
        spr_h = 8
        active = true
        max_vel = 0.6
        vel_decay = 0.1
        fire_time = 0
        fire_rate = 0.6
        exh_spr_id = 5
        exh_anim_spd = 1.6
        exh_frame = 0
        exh_frame_pos = 0
        exh_nframes = 5
        muzzle_r = 0
        muzzle_rmax = 3
        lives = 4
        full_heart_spr = 14
        empty_heart_spr = 15
        is_hit = false
        invulerable_time = 30
        layer = LAYER_PLAYER
        mask = (LAYER_ENEMY | LAYER_ENEMY_BULLET)
        add(g_obj_manager.friend_objs, _ENV)
    end,

    update = function(_ENV)
        _ENV:player_ctrls()
        _ENV:bound_player()

        fire_time += g_dt

        -- Apply velocity decay when no input is given
        if not (btn(0) or btn(1)) then
            vel_x -= acc_rate * sign(vel_x)
            if abs(vel_x) < 0.1 then
                vel_x = 0
            end
        end
        if not (btn(2) or btn(3)) then
            vel_y -= acc_rate * sign(vel_y)
            if abs(vel_y) < 0.1 then
                vel_y = 0
            end
        end


        if is_hit then
            invulerable_time -= 1
            mask = 0

            if invulerable_time <= 0 then
                is_hit = false
                mask = (LAYER_ENEMY | LAYER_ENEMY_BULLET)
                invulerable_time = 30
            end
        end


        -- clamp velocities
        if ssqr(vel_x, vel_y) > max_spd * max_spd then
            local nvel_x, nvel_y = norm(vel_x, vel_y)
            vel_x = nvel_x * max_spd
            vel_y = nvel_y * max_spd
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

        -- update muzzle
        muzzle_r -= 1
        muzzle_r = mid(0, muzzle_r, muzzle_rmax)


        -- update spr pos
        spr_x = pos_x
        spr_y = pos_y

        -- update physics
        vel_x += acc_x
        vel_y += acc_y
        pos_x += vel_x
        pos_y += vel_y

    end,

    draw = function(_ENV)
        -- set left, right and idle sprites
        if btn(0) then
            spr_id = 1
        elseif btn(1) then
            spr_id = 3
        else
            spr_id = 2
        end

        if not is_hit or sin(g_time * 5) < 0.2 then
            spr(exh_spr_id + exh_frame, pos_x, pos_y + 8)
            spr(spr_id + frame, pos_x, pos_y)
        end

        -- muzzle flash
        if muzzle_r ~= 0 then
            circfill(pos_x + 3, pos_y - 1, muzzle_r, 7)
        end
    end,

    player_ctrls = function(_ENV)
        acc_x = 0
        acc_y = 0

        if btn(0) then
            acc_x = -1 -- Move left
        elseif btn(1) then
            acc_x = 1  -- Move right
        end

        if btn(2) then
            acc_y = -1 -- Move up
        elseif btn(3) then
            acc_y = 1  -- Move down
        end

        acc_x, acc_y = norm(acc_x, acc_y)


        if btnp(4) then
            if fire_time > fire_period then
                _ENV:shoot_bullet()
            end
        end
    end,

    shoot_bullet = function(_ENV)
        sfx(0)
        pbullet_obj:new({ pos_x = pos_x, pos_y = pos_y - 2, vel_y = -6 })
        muzzle_r = muzzle_rmax
        fire_time = 0
    end,

    bound_player = function(_ENV)
        pos_x = mid(0, pos_x, g_scrn[1] - 8)
        pos_y = mid(0, pos_y, g_scrn[2] - 8)
    end,

    resolve_collision = function(_ENV, other_obj)
        if is_hit then
            return
        end

        -- collision with enemy
        if other_obj.layer == LAYER_ENEMY then
            sfx(1)
            lives -= 1
            is_hit = true

        -- collision with enemy bullets
        elseif other_obj.layer == LAYER_ENEMY_BULLET then
            sfx(1)
            lives -= 1
            is_hit = true
        end

        camera_obj:set_shake(0.5, 0.5)
        spark_particles(5, pos_x, pos_y)
        shockwave_particles(pos_x, pos_y, 1 + rnd(2), 20)
    end,

})
