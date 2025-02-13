player_obj = game_object:new({
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
    name = "player",
    active = true,

    rad = 10,
    off_x = 4,
    off_y = 4,
    
    spr_x = 0,
    spr_y = 0,
    spr_w = 8,
    spr_h = 8,


    max_vel = 1,

    vel_decay = 0.05,
    acc_decay = 0.1,

    fire_time = 0,
    fire_rate = 0.3,

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

    layer = LAYER_PLAYER,
    mask = (LAYER_ENEMY | LAYER_ENEMY_BULLET),

    init = function(_ENV)
        sprite_id = 2
        pos_x = 64
        pos_y = 80
        vel_x = 0
        vel_y = 0
        acc_x = 0
        acc_y = 0
        frame = 0
        frame_pos = 0
        anim_speed = 0
        nframes = 0
        name = "player"
        active = true
        max_vel = 0.6
        vel_decay = 0.05
        acc_decay = 0.1
        fire_time = 0
        fire_rate = 0.3
        exh_spr_id = 5
        exh_anim_spd = 0.8
        exh_frame = 0
        exh_frame_pos = 0
        exh_nframes = 5
        muzzle_r = 0
        muzzle_rmax = 5
        lives = 4
        full_heart_spr = 14
        empty_heart_spr = 15
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


       _ENV:resolve_collision()



        -- clamp velocities
        if ssqr(vel_x, vel_y) > max_vel * max_vel then
            local nvel_x, nvel_y = norm(vel_x, vel_y)
            vel_x = nvel_x * max_vel
            vel_y = nvel_y * max_vel
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

        -- update physics
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

        spr_x = pos_x
        spr_y = pos_y
        rectfill( spr_x, spr_y, spr_x + spr_w, spr_y+spr_h, 8 )

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
        add(g_obj_manager.g_objs, bullet_obj:new({ pos_x = pos_x, pos_y = pos_y - 2 }))
        muzzle_r = muzzle_rmax
        fire_time = 0
    end,

    bound_player = function(_ENV)
        pos_x = mid(0, pos_x, g_scrn[1] - 8)
        pos_y = mid(0, pos_y, g_scrn[2] - 8)
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

            -- collision with enemy
            if l == LAYER_ENEMY then
                stop("collision detected")
                g_obj.lives -= 1
                lives -= 1

            -- collision with enemy bullets
            elseif l == LAYER_ENEMY_BULLET then
                g_obj.active = false
                lives -= 1
            end
        end
    end,

})
