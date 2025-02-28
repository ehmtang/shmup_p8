ENEM_DEFAULT = 0
ENEM_HOMING = 1
ENEM_SINE_WAVE = 2
ENEM_TELEPORT = 3

enemy_obj = game_object:new({

    max_vel = 1,
    n_wave = 0,

    vel_decay = 0.05,
    acc_decay = 0.1,

    fire_time = 0,
    fire_rate = 0.3,
    lives = 4,
    flash_time = 0,

    start_pos_x = 0,
    start_pos_y = 0,

    state = "enter",
    pattern = ENEM_DEFAULT,

    init = function(_ENV)
        game_object:init()
        spr_id = 21
        anim_spd = 0.2
        nframes = 4
        name = "enemy"
        rad = 10
        spr_w = 8
        spr_h = 8
        layer = LAYER_ENEMY
        mask = LAYER_PLAYER | LAYER_PLAYER_BULLET
        add(g_obj_manager.enemy_objs, _ENV)
    end,

    update = function(_ENV)
        if state == "enter" then
            _ENV:update_enter()
        end

        fire_time += g_dt




        -- clamp velocities
        if ssqr(vel_x, vel_y) > max_vel * max_vel then
            local nvel_x, nvel_y = norm(vel_x, vel_y)
            vel_x = nvel_x * max_vel
            vel_y = nvel_y * max_vel
        end

        -- exhaust animation
        frame_pos += anim_spd
        if (frame_pos > 1) then
            frame += 1
            frame_pos -= 1

            if frame >= nframes then
                frame = 0
            end
        end

        flash_time -= 1


        -- update spr pos
        spr_x = pos_x
        spr_y = pos_y

        -- update physics
        vel_x += acc_x
        vel_y += acc_y
        pos_x += vel_x
        pos_y += vel_y
    end,

    update_enter = function(_ENV)
        local t = g_dt * 0.5

        pos_x = lerp(pos_x, start_pos_x, easeOutQuad(t))
        pos_y = lerp(pos_y, start_pos_y, easeOutQuad(t))
    end,

    draw = function(_ENV)
        -- Apply flash effect only if this enemy is hit
        if flash_time > 0 then
            pal(3, 7)
            pal(11, 7)
        end

        spr_x = pos_x
        spr_y = pos_y
        --rectfill(spr_x, spr_y, spr_x + spr_w, spr_y + spr_h, 8)

        spr(spr_id + frame, pos_x, pos_y)
        -- Reset palette after drawing this enemy
        pal()
    end,

    shoot_bullet = function(_ENV)
        sfx(0)
        e_bullet_obj:new({ pos_x = pos_x, pos_y = pos_y - 2 })
        fire_time = 0
    end,

    resolve_collision = function(_ENV, other_obj)
        if other_obj.layer == LAYER_PLAYER_BULLET then
            sfx(1)
            lives -= 1
            flash_time = 3

            spark_particles(5, pos_x, pos_y)

            -- 1 in 3 chance
            if flr(rnd(3)) + 1 == 1 then
                shockwave_particles(pos_x, pos_y)
            end

            if lives <= 0 then
                sfx(2)
                active = false
                level_fs.score += 1
                explosion_particles(10, pos_x, pos_y)
                shockwave_particles(pos_x, pos_y, 5 + rnd(3), rnd(10))
            end
        end
    end,
})


enemyBoss_obj = enemy_obj:new({
    init = function(_ENV)
        game_object:init()
        spr_id = 25
        anim_spd = 0.2
        nframes = 0
        name = "enemyBoss"
        rad = 10
        spr_w = 16
        spr_h = 16
        layer = LAYER_ENEMY
        mask = LAYER_PLAYER_BULLET
        lives = 10
    end,

    draw = function(_ENV)
        -- Apply flash effect only if this enemy is hit
        if flash_time > 0 then
            pal(3, 7)
            pal(11, 7)
        end

        spr_x = pos_x
        spr_y = pos_y
        --rectfill(spr_x, spr_y, spr_x + spr_w, spr_y + spr_h, 8)

        spr(spr_id + frame, pos_x, pos_y, 2, 2)
        -- Reset palette after drawing this enemy
        pal()
    end,
})
