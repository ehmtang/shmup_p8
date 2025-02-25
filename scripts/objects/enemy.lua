DEFAULT = 0
HOMING = 1
SINE_WAVE = 2
TELEPORT = 3

enemy_obj = game_object:new({

    max_vel = 1,
    n_wave = 0,

    vel_decay = 0.05,
    acc_decay = 0.1,

    fire_time = 0,
    fire_rate = 0.3,
    lives = 4,
    flash_time = 0,
    pattern = DEFAULT,

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
    end,

    update = function(_ENV)
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

        _ENV:resolve_collision()
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
        add(g_obj_manager.g_objs, e_bullet_obj:new({ pos_x = pos_x, pos_y = pos_y - 2 }))
        fire_time = 0
    end,

    resolve_collision = function(_ENV)
        local collisions = {}
        for i = 1, #g_obj_manager.g_objs do
            local g_obj = g_obj_manager.g_objs[i]

            -- Filter and check for collision in one pass
            if g_obj.layer and g_obj.active and canCollide(mask, g_obj.layer) and aabb_intersect(_ENV, g_obj) then
                add(collisions, g_obj)
            end
        end

        for i = 1, #collisions do
            local g_obj = collisions[i]
            local l = g_obj.layer

            -- collision with enemy bullets
            if l == LAYER_PLAYER_BULLET then
                sfx(1)
                g_obj.active = false
                lives -= 1
                flash_time = 3

                if lives <= 0 then
                    sfx(2)
                    active = false
                    level_fs.score += 1

                    -- create explosion particles
                    local colours = { 8, 9, 10, 11, 12, 13, 14, 15 }
                    for i = 1, 10 + rnd(10) do
                        local particle = particle_object:new({
                            pos_x = pos_x + 4 + rnd(4),
                            pos_y = pos_y + 4 + rnd(4),
                            vel_x = rnd() - 0.5,
                            vel_y = rnd() - 0.5,
                            clr = rnd(colours),
                            rad = rnd() * 3,
                            age = rnd() * 5,
                            rad_inc = 0.01
                        })
                        add(g_obj_manager.p_objs, particle)
                    end

                    -- create shockwave particle
                    local particle = particle_object:new({
                        pos_x = pos_x + 4,
                        pos_y = pos_y + 4,
                        clr = 7,
                        rad = 5 + rnd(3),
                        rad_inc = 0.2,
                        clear = true,
                        age = rnd(10)
                    })
                    add(g_obj_manager.p_objs, particle)
                end

                -- create spark particles
                for i = 1, 5 + rnd(5) do
                    local particle = particle_object:new({
                        pos_x = pos_x + 4,
                        pos_y = pos_y + 4,
                        vel_x = rnd() - 0.5,
                        vel_y = rnd() - 0.5,
                        clr = 7,
                        rad = 0,
                    })
                    add(g_obj_manager.p_objs, particle)
                end

                -- 1 in 3 chance
                if flr(rnd(3)) + 1 == 1 then
                    -- create shockwave particle
                    local particle = particle_object:new({
                        pos_x = pos_x + 4,
                        pos_y = pos_y + 4,
                        clr = 7,
                        rad = 1 + rnd(2),
                        rad_inc = 0.2,
                        clear = true,
                        age = 20
                    })
                    add(g_obj_manager.p_objs, particle)
                end
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

        spr(spr_id + frame, pos_x, pos_y, 2,2)
        -- Reset palette after drawing this enemy
        pal()
    end,
})

